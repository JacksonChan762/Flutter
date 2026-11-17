import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:edusnap/Models/JournalEntry.dart';
import 'package:edusnap/Pages/Add/AddPage.dart';
import 'package:edusnap/Pages/Add/AddPageController.dart';
import 'package:edusnap/Pages/HomePage/HomePageController.dart';
import 'package:edusnap/Services/journal_repository.dart';
import 'package:edusnap/Services/photo_picker_service.dart';
import 'package:edusnap/Services/photo_store.dart';
import 'package:edusnap/Services/settings_repository.dart';
import 'package:edusnap/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fakes.dart';

class StubPhotoPicker extends PhotoPickerService {
  PhotoPickResult result = const PhotoPickResult(
    PhotoPickStatus.picked,
    path: '/source.jpg',
  );
  Completer<PhotoPickResult>? pending;
  bool settingsOpened = false;

  @override
  Future<PhotoPickResult> pick(PhotoSource source) async =>
      pending == null ? result : pending!.future;

  @override
  Future<bool> openSettings() async => settingsOpened = true;
}

class BrokenPhotoStore extends FakePhotoStore {
  @override
  Future<String> save(String sourcePath, String entryId) async =>
      throw const FileSystemException('No space');
}

class DelayedJournalRepository extends FakeJournalRepository {
  final started = Completer<void>();
  final release = Completer<void>();
  int writes = 0;

  @override
  Future<void> save(List<JournalEntry> entries) async {
    writes++;
    if (writes == 1) {
      started.complete();
      await release.future;
    }
    await super.save(entries);
  }
}

class CancelledImagePicker extends ImagePicker {
  @override
  Future<XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async => null;
}

JournalEntry original() => JournalEntry(
  id: 'entry-0',
  title: 'Original',
  note: 'Keep me',
  createdAt: DateTime(2026),
  photoPath: '/photos/original.jpg',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'fresh install gets three samples once; clear survives reopening',
    () async {
      useEmptyPreferences();
      final first = await JournalRepository().load();
      expect(first, hasLength(3));
      final reopened = await JournalRepository().load();
      expect(reopened.map((e) => e.id), first.map((e) => e.id));
      await JournalRepository().clear();
      expect(await JournalRepository().load(), isEmpty);
    },
  );

  test(
    'real JSON repository reloads saved edits and preserves legacy identities',
    () async {
      SharedPreferences.setMockInitialValues({
        JournalRepository.entriesKey: jsonEncode([original().toJson()]),
      });
      final home = HomePageController(photoStore: FakePhotoStore());
      await home.load();
      final newEntry = JournalEntry(
        title: 'New after restart',
        note: '',
        createdAt: DateTime(2026),
      );
      expect(newEntry.id, isNot('entry-0'));
      await home.add(newEntry);
      await home.update(home.entries.last.copyWith(title: 'Edited original'));
      home.dispose();
      final reopened = HomePageController(photoStore: FakePhotoStore());
      addTearDown(reopened.dispose);
      await reopened.load();
      expect(reopened.entries.map((e) => e.title), [
        'New after restart',
        'Edited original',
      ]);
      expect(reopened.entries.last.photoPath, '/photos/original.jpg');
      expect(reopened.entries.map((e) => e.id).toSet(), hasLength(2));
      await reopened.clearAll();
      expect(await JournalRepository().load(), isEmpty);
    },
  );

  test(
    'new entry IDs are unique independently of sample and legacy counters',
    () {
      final ids = List.generate(
        1000,
        (_) => JournalEntry(title: 'A', note: '', createdAt: DateTime(2026)).id,
      );
      expect(ids.toSet(), hasLength(1000));
      expect(ids, everyElement(matches(RegExp(r'^entry-[0-9a-f]{32}$'))));
    },
  );

  test(
    'overlapping mutations persist in order instead of losing newer entries',
    () async {
      final repo = DelayedJournalRepository();
      final home = HomePageController(
        repository: repo,
        photoStore: FakePhotoStore(),
      );
      addTearDown(home.dispose);
      await home.load();
      final first = home.add(
        JournalEntry(title: 'First', note: '', createdAt: DateTime(2026)),
      );
      final second = home.add(
        JournalEntry(title: 'Second', note: '', createdAt: DateTime(2026)),
      );
      await repo.started.future;
      expect(repo.writes, 1);
      repo.release.complete();
      await Future.wait([first, second]);
      expect(repo.stored.map((entry) => entry.title), ['Second', 'First']);
    },
  );

  test('language choice loads from a fresh repository instance', () async {
    useEmptyPreferences();
    await SettingsRepository().saveLanguageCode('zh');
    expect(await SettingsRepository().loadLanguageCode(), 'zh');
  });

  test(
    'real file copies preserve saved bytes and cleanup keeps referenced photos',
    () async {
      final directory = await Directory.systemTemp.createTemp('edusnap-audit-');
      addTearDown(() => directory.delete(recursive: true));
      final source = File('${directory.path}/source.jpg');
      await source.writeAsBytes([1, 2, 3]);
      final store = PhotoStore(documentsDirectory: () async => directory);
      final saved = await store.save(source.path, 'same-entry');
      await source.writeAsBytes([4, 5, 6, 7]);
      final replacement = await store.save(source.path, 'same-entry');
      expect(replacement, isNot(saved));
      expect(await File(saved).readAsBytes(), [1, 2, 3]);
      expect(await File(replacement).readAsBytes(), [4, 5, 6, 7]);
      expect(await store.usedBytes(), 7);
      expect(await store.deleteUnused({saved}), 1);
      expect(await File(saved).exists(), isTrue);
      expect(await store.usedBytes(), 3);
      await store.deleteUnused({});
      expect(await store.usedBytes(), 0);
    },
  );

  test(
    'cancelling photo replacement preserves saved photo and removes draft',
    () async {
      final photos = FakePhotoStore()..files.add('/photos/original.jpg');
      final c = AddPageController(
        entry: original(),
        pickerService: StubPhotoPicker(),
        photoStore: photos,
      );
      await c.pickPhoto(PhotoSource.gallery);
      expect(photos.files, contains('/photos/original.jpg'));
      expect(photos.files, hasLength(2));
      c.dispose();
      expect(photos.files, {'/photos/original.jpg'});
    },
  );

  test(
    'removing a photo then cancelling the edit preserves original',
    () async {
      final photos = FakePhotoStore()..files.add('/photos/original.jpg');
      final c = AddPageController(entry: original(), photoStore: photos);
      await c.removePhoto();
      expect(c.photoPath, isNull);
      c.dispose();
      expect(photos.files, {'/photos/original.jpg'});
    },
  );

  test(
    'committing replacement transfers draft ownership and deletes old photo',
    () async {
      final photos = FakePhotoStore()..files.add('/photos/original.jpg');
      final repo = FakeJournalRepository([original()]);
      final home = HomePageController(repository: repo, photoStore: photos);
      addTearDown(home.dispose);
      await home.load();
      final c = AddPageController(
        entry: original(),
        pickerService: StubPhotoPicker(),
        photoStore: photos,
      );
      await c.pickPhoto(PhotoSource.gallery);
      await c.pickPhoto(PhotoSource.gallery);
      expect(photos.files, hasLength(2));
      final saved = c.save()!;
      c.dispose();
      expect(photos.files, contains(saved.photoPath));
      await home.update(saved);
      expect(photos.files, {saved.photoPath});
      expect(repo.stored.single.photoPath, saved.photoPath);
    },
  );

  test(
    'abandoned Add draft is deleted, while saved Add photo is retained',
    () async {
      final photos = FakePhotoStore();
      final cancelled = AddPageController(
        pickerService: StubPhotoPicker(),
        photoStore: photos,
      );
      await cancelled.pickPhoto(PhotoSource.camera);
      cancelled.dispose();
      expect(photos.files, isEmpty);
      final committed = AddPageController(
        pickerService: StubPhotoPicker(),
        photoStore: photos,
      );
      committed.title.text = 'A moment';
      await committed.pickPhoto(PhotoSource.gallery);
      final entry = committed.save()!;
      committed.dispose();
      expect(photos.files, {entry.photoPath});
    },
  );

  test('photo copy failure keeps the previous saved photo', () async {
    final photos = BrokenPhotoStore()..files.add('/photos/original.jpg');
    final c = AddPageController(
      entry: original(),
      pickerService: StubPhotoPicker(),
      photoStore: photos,
    );
    addTearDown(c.dispose);
    expect(
      (await c.pickPhoto(PhotoSource.gallery)).status,
      PhotoPickStatus.failed,
    );
    expect(c.photoPath, '/photos/original.jpg');
    expect(photos.files, {'/photos/original.jpg'});
  });

  test('leaving during permission/picker wait discards the result', () async {
    final picker = StubPhotoPicker()..pending = Completer<PhotoPickResult>();
    final photos = FakePhotoStore();
    final c = AddPageController(pickerService: picker, photoStore: photos);
    c.title.text = 'Pending';
    final picking = c.pickPhoto(PhotoSource.gallery);
    expect(c.save(), isNull);
    c.dispose();
    picker.pending!.complete(
      const PhotoPickResult(PhotoPickStatus.picked, path: '/late.jpg'),
    );
    expect((await picking).status, PhotoPickStatus.cancelled);
    expect(photos.files, isEmpty);
  });

  const permissionChannel = MethodChannel(
    'flutter.baseflow.com/permissions/methods',
  );
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  for (final sdk in [32, 33, 34]) {
    test('Android $sdk requests the matching gallery permission', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final requested = <int>[];
      messenger.setMockMethodCallHandler(permissionChannel, (call) async {
        if (call.method == 'checkPermissionStatus') {
          return PermissionStatus.denied.index;
        }
        if (call.method == 'requestPermissions') {
          requested.addAll(List<int>.from(call.arguments));
          return {
            for (final id in requested) id: PermissionStatus.granted.index,
          };
        }
        return null;
      });
      addTearDown(() {
        messenger.setMockMethodCallHandler(permissionChannel, null);
        debugDefaultTargetPlatformOverride = null;
      });
      expect(
        await PhotoPickerService(androidSdk: () async => sdk)
            .requestPermission(PhotoSource.gallery),
        isTrue,
      );
      expect(requested, [
        (sdk < 33 ? Permission.storage : Permission.photos).value,
      ]);
    });
  }

  test(
    'limited photo access is accepted and picker cancellation is quiet',
    () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      messenger.setMockMethodCallHandler(
        permissionChannel,
        (call) async => PermissionStatus.limited.index,
      );
      addTearDown(() {
        messenger.setMockMethodCallHandler(permissionChannel, null);
        debugDefaultTargetPlatformOverride = null;
      });
      final result = await PhotoPickerService(picker: CancelledImagePicker())
          .pick(PhotoSource.gallery);
      expect(result.status, PhotoPickStatus.cancelled);
    },
  );

  test(
    'native permission exceptions are returned as a recoverable failure',
    () async {
      messenger.setMockMethodCallHandler(
        permissionChannel,
        (_) async => throw PlatformException(code: 'unavailable'),
      );
      addTearDown(
        () => messenger.setMockMethodCallHandler(permissionChannel, null),
      );
      expect(
        (await PhotoPickerService().pick(PhotoSource.camera)).status,
        PhotoPickStatus.failed,
      );
    },
  );

  testWidgets('denied photo permission explains access and opens settings', (
    tester,
  ) async {
    final picker = StubPhotoPicker()
      ..result = const PhotoPickResult(PhotoPickStatus.denied);
    await tester.pumpWidget(
      EduSnapApp(
        home: (_) => AddPage(
          controller: AddPageController(
            pickerService: picker,
            photoStore: FakePhotoStore(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('pick-photo')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose from gallery'));
    await tester.pumpAndSettle();
    expect(find.text('Permission needed'), findsOneWidget);
    await tester.tap(find.text('Open settings'));
    await tester.pumpAndSettle();
    expect(picker.settingsOpened, isTrue);
    expect(find.byKey(const ValueKey('title')), findsOneWidget);
  });
}
