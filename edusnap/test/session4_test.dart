import 'dart:async';

import 'package:edusnap/Pages/HomePage/HomePage.dart';
import 'package:edusnap/Services/duo_platform.dart';
import 'package:edusnap/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itchi_flutter_duo_layout/itchi_flutter_duo_layout.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'fakes.dart';

class FakeDuoPlatform implements DuoPlatform {
  final foldController = StreamController<DuoFoldSnapshot>.broadcast();
  final backController = StreamController<void>.broadcast();
  final visibility = <bool>[];
  ItchiSideBackStatus status = ItchiSideBackStatus.available;
  int unavailableResponses = 0;
  bool fail = false;

  @override
  bool get isSupported => true;
  @override
  Stream<DuoFoldSnapshot> get folds => foldController.stream;
  @override
  Stream<void> get backPresses => backController.stream;
  @override
  Future<ItchiSideBackStatus> setBackVisible(bool visible) async {
    visibility.add(visible);
    if (fail) throw StateError('Native view disconnected');
    if (unavailableResponses > 0) {
      unavailableResponses--;
      return ItchiSideBackStatus.viewUnavailable;
    }
    return status;
  }

  Future<void> close() async {
    await foldController.close();
    await backController.close();
  }
}

void mockVersion(String version, String build) {
  PackageInfo.setMockInitialValues(
    appName: 'EduSnap',
    packageName: 'com.example.edusnap',
    version: version,
    buildNumber: build,
    buildSignature: '',
  );
}

Future<void> launch(WidgetTester tester, {DuoPlatform? duo}) async {
  useEmptyPreferences();
  mockVersion('9.8.7', '42');
  await tester.pumpWidget(
    EduSnapApp(
      duoPlatform: duo,
      home: (onLanguageChanged) => HomePage(
        onLanguageChanged: onLanguageChanged,
        repository: FakeJournalRepository(),
        photoStore: FakePhotoStore(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Settings reads version and build again when reopened', (
    tester,
  ) async {
    await launch(tester);
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('app-version')),
      150,
    );
    expect(find.text('Version 9.8.7 (build 42)'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    mockVersion('9.8.8', '43');
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('app-version')),
      150,
    );
    expect(find.text('Version 9.8.8 (build 43)'), findsOneWidget);
  });

  testWidgets('native rail follows routes and dismisses a dialog before Add', (
    tester,
  ) async {
    final duo = FakeDuoPlatform();
    addTearDown(duo.close);
    await launch(tester, duo: duo);
    expect(duo.visibility.last, isFalse);
    await tester.tap(find.byTooltip('Add entry'));
    await tester.pumpAndSettle();
    expect(duo.visibility.last, isTrue);
    expect(find.byType(BackButton), findsNothing);

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Title missing'), findsOneWidget);
    duo.backController.add(null);
    await tester.pumpAndSettle();
    expect(find.text('Title missing'), findsNothing);
    expect(find.byType(Form), findsOneWidget);
    duo.backController.add(null);
    await tester.pumpAndSettle();
    expect(find.byType(Form), findsNothing);
    expect(duo.visibility.last, isFalse);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    expect(duo.foldController.hasListener, isFalse);
    expect(duo.backController.hasListener, isFalse);
    expect(duo.visibility.last, isFalse);
  });

  testWidgets('one native Duo tap dismisses only the top route', (
    tester,
  ) async {
    const rail = MethodChannel('itchi_flutter_duo_layout/side_back');
    const fold = MethodChannel('itchi_flutter_duo_layout/fold');
    const codec = StandardMethodCodec();
    final messenger = tester.binding.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(
      rail,
      (call) async => {'status': 'available'},
    );
    messenger.setMockMethodCallHandler(fold, (call) async => null);

    Future<void> tapNativeBack() async {
      await messenger.handlePlatformMessage(
        rail.name,
        codec.encodeMethodCall(const MethodCall('onItemTap', {'id': 'back'})),
        null,
      );
      await tester.pump();
      await messenger.handlePlatformMessage(
        rail.name,
        codec.encodeMethodCall(const MethodCall('onBack')),
        null,
      );
      await tester.pumpAndSettle();
    }

    await launch(tester, duo: PluginDuoPlatform());
    await tester.tap(find.byTooltip('Add entry'));
    await tester.pumpAndSettle();
    expect(find.byType(BackButton), findsNothing);
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Title missing'), findsOneWidget);

    await tapNativeBack();
    expect(find.text('Title missing'), findsNothing);
    expect(find.byType(Form), findsOneWidget);

    await tapNativeBack();
    expect(find.byType(Form), findsNothing);
  }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

  for (final status in [
    ItchiSideBackStatus.unsupportedPlatform,
    ItchiSideBackStatus.unknown,
    ItchiSideBackStatus.viewUnavailable,
  ]) {
    testWidgets('Flutter Back stays usable when rail reports $status', (
      tester,
    ) async {
      final duo = FakeDuoPlatform()..status = status;
      addTearDown(duo.close);
      await launch(tester, duo: duo);
      await tester.tap(find.byTooltip('Add entry'));
      await tester.pumpAndSettle();
      expect(find.byType(BackButton), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(Form), findsNothing);
    });
  }

  testWidgets('a bridge failure restores Flutter Back after a working rail', (
    tester,
  ) async {
    final duo = FakeDuoPlatform();
    addTearDown(duo.close);
    await launch(tester, duo: duo);
    await tester.tap(find.byTooltip('Add entry'));
    await tester.pumpAndSettle();
    expect(find.byType(BackButton), findsNothing);
    duo.fail = true;
    duo.foldController.add(
      DuoFoldSnapshot.unavailable(DuoFoldAvailability.viewUnavailable),
    );
    await tester.pumpAndSettle();
    expect(find.byType(BackButton), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
  });

  testWidgets('a temporarily unavailable native view is retried', (
    tester,
  ) async {
    final duo = FakeDuoPlatform();
    addTearDown(duo.close);
    await launch(tester, duo: duo);
    duo.unavailableResponses = 1;
    final callsBefore = duo.visibility.length;
    await tester.tap(find.byTooltip('Add entry'));
    await tester.pumpAndSettle();
    expect(duo.visibility.length - callsBefore, 2);
    expect(find.byType(BackButton), findsNothing);
  });

  testWidgets(
    'fully open uses screen width and closing restores readable width',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final duo = FakeDuoPlatform();
      addTearDown(duo.close);
      await launch(tester, duo: duo);
      await tester.tap(find.byTooltip('Add entry'));
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(Form)).width, 720);
      for (final pose in ['fullyOpen', 'closed', 'fullyOpenHalfScreen']) {
        duo.foldController.add(
          DuoFoldSnapshot.fromMessage({
            'version': 1,
            'availability': 'available',
            'pose': pose,
            'hingeStatus': pose == 'closed' ? 'closed' : 'fullyOpen',
          }),
        );
        await tester.pumpAndSettle();
        expect(
          tester.getSize(find.byType(Form)).width,
          pose == 'fullyOpen' ? 1200 : 720,
        );
      }
      duo.foldController.addError(StateError('Fold stream interrupted'));
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(Form)).width, 720);
    },
  );
}
