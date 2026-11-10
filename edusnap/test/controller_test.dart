import 'package:flutter_test/flutter_test.dart';
import 'package:edusnap/Models/JournalEntry.dart';
import 'package:edusnap/Pages/HomePage/HomePageController.dart';
import 'package:edusnap/Pages/Add/AddPageController.dart';
import 'package:edusnap/Pages/Settings/SettingsPageController.dart';
import 'package:edusnap/Utils/date_formatter.dart';

import 'fakes.dart';

void main() {
  test('loads saved entries, then add, update and remove persist', () async {
    final saved = JournalEntry(
      title: 'Saved',
      note: 'from disk',
      createdAt: DateTime(2026, 1, 2),
      photoPath: '/photos/saved.jpg',
    );
    final repo = FakeJournalRepository([saved]);
    final photos = FakePhotoStore()..files.add('/photos/saved.jpg');
    final c = HomePageController(repository: repo, photoStore: photos);
    addTearDown(c.dispose);
    var notifications = 0;
    c.addListener(() => notifications++);

    await c.load();
    expect(c.isLoaded, isTrue);
    expect(c.entries.single.title, 'Saved');
    expect(c.entries.single.photoPath, '/photos/saved.jpg');
    expect(() => c.entries.clear(), throwsUnsupportedError);

    final entry = JournalEntry(
      title: 'New',
      note: '',
      createdAt: DateTime(2026),
    );
    await c.add(entry);
    expect(c.entries.first, entry);
    expect(repo.stored.first, entry);

    final edited = entry.copyWith(title: 'Updated');
    await c.update(edited);
    expect(c.entries.first.title, 'Updated');
    expect(c.entries.first.createdAt, entry.createdAt);
    expect(repo.stored.first.title, 'Updated');

    await c.remove(edited);
    expect(c.entries, hasLength(1));
    expect(repo.stored, hasLength(1));
    expect(notifications, 4);
  });

  test('removing or replacing an entry deletes its photo file', () async {
    final entry = JournalEntry(
      title: 'With photo',
      note: '',
      createdAt: DateTime(2026),
      photoPath: '/photos/old.jpg',
    );
    final photos = FakePhotoStore()..files.add('/photos/old.jpg');
    final c = HomePageController(
      repository: FakeJournalRepository([entry]),
      photoStore: photos,
    );
    addTearDown(c.dispose);
    await c.load();

    // The new path is produced by the picker/store, so register it first.
    photos.files.add('/photos/new.jpg');
    await c.update(entry.copyWith(photoPath: '/photos/new.jpg'));
    expect(photos.files, {'/photos/new.jpg'});

    await c.remove(c.entries.first);
    expect(photos.files, isEmpty);
  });

  test('clearAll empties the journal and its photos', () async {
    final repo = FakeJournalRepository([
      JournalEntry(
        title: 'A',
        note: '',
        createdAt: DateTime(2026),
        photoPath: '/photos/a.jpg',
      ),
    ]);
    final photos = FakePhotoStore()..files.addAll(['/photos/a.jpg']);
    final c = HomePageController(repository: repo, photoStore: photos);
    addTearDown(c.dispose);
    await c.load();

    await c.clearAll();
    expect(c.entries, isEmpty);
    expect(repo.stored, isEmpty);
    expect(photos.files, isEmpty);
  });

  test('add trims title, rejects whitespace, note is optional', () {
    final c = AddPageController();
    addTearDown(c.dispose);
    c.title.text = '   ';
    expect(c.save(), isNull);
    c.title.text = '  Hello  ';
    expect(c.save()!.title, 'Hello');
    expect(c.save()!.note, isEmpty);
    expect(c.save()!.photoPath, isNull);
  });

  test('edit preserves identity, createdAt and photo', () {
    final original = JournalEntry(
      title: 'Before',
      note: 'Note',
      createdAt: DateTime(2026, 1, 2),
      photoPath: '/photos/keep.jpg',
    );
    final c = AddPageController(entry: original);
    addTearDown(c.dispose);
    expect(c.title.text, 'Before');
    expect(c.note.text, 'Note');
    expect(c.photoPath, '/photos/keep.jpg');
    c.title.text = 'After';
    final result = c.save()!;
    expect(result.id, original.id);
    expect(result.createdAt, original.createdAt);
    expect(result.photoPath, '/photos/keep.jpg');
    expect(original.title, 'Before');
  });

  test('removing the photo clears it on save', () async {
    final original = JournalEntry(
      title: 'Photo',
      note: '',
      createdAt: DateTime(2026),
      photoPath: '/photos/x.jpg',
    );
    final c = AddPageController(entry: original);
    addTearDown(c.dispose);
    await c.removePhoto();
    expect(c.photoPath, isNull);
    expect(c.save()!.photoPath, isNull);
  });

  test('entry JSON round trip keeps every field', () {
    final entry = JournalEntry(
      title: 'JSON',
      note: 'note',
      createdAt: DateTime(2026, 3, 4, 5, 6),
      photoPath: '/photos/json.jpg',
    );
    final copy = JournalEntry.fromJson(entry.toJson())!;
    expect(copy.id, entry.id);
    expect(copy.title, 'JSON');
    expect(copy.note, 'note');
    expect(copy.createdAt, entry.createdAt);
    expect(copy.photoPath, '/photos/json.jpg');
    expect(JournalEntry.fromJson({'id': 'x'}), isNull);
    expect(JournalEntry.fromJson('nope'), isNull);
  });

  test('settings controller saves language and reports storage', () async {
    final photos = FakePhotoStore()..files.addAll(['/a.jpg', '/b.jpg']);
    final settings = FakeSettingsRepository();
    final c = SettingsPageController(
      photoStore: photos,
      settingsRepository: settings,
    );
    addTearDown(c.dispose);
    await c.load();
    expect(c.usedBytes, 4096);

    await c.changeLanguage('zh');
    expect(settings.code, 'zh');

    final removed = await c.formatStorage({'/a.jpg'});
    expect(removed, 1);
    expect(c.usedBytes, 2048);

    await c.clearAll(() async {});
    expect(c.usedBytes, 0);
  });

  test('storage size formatting', () {
    expect(formatBytes(0), '0 KB');
    expect(formatBytes(900), '0 KB');
    expect(formatBytes(2048), '2 KB');
    expect(formatBytes(1536 * 1024), '1.5 MB');
  });

  test('dates are formatted for display', () {
    expect(formatJournalDate(DateTime(2026, 1, 2)), contains('2026'));
  });
}
