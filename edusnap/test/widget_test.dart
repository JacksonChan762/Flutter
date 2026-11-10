import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edusnap/main.dart';
import 'package:edusnap/Pages/HomePage/HomePage.dart';
import 'package:edusnap/Models/JournalEntry.dart';
import 'package:edusnap/Component/JournalCard/journal_card.dart';

import 'fakes.dart';

Future<void> openAdd(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Add entry'));
  await tester.pumpAndSettle();
}

Future<void> back(WidgetTester tester) async {
  await tester.pageBack();
  await tester.pumpAndSettle();
}

Future<void> pumpApp(
  WidgetTester tester, {
  FakeJournalRepository? repository,
  FakePhotoStore? photos,
  FakeSettingsRepository? settings,
  String? language,
}) async {
  useEmptyPreferences();
  await tester.pumpWidget(
    EduSnapApp(
      initialLanguageCode: language,
      settingsRepository: settings,
      home: (onLanguageChanged) => HomePage(
        onLanguageChanged: onLanguageChanged,
        repository: repository,
        photoStore: photos,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

JournalEntry sample(String title, {String? photo}) => JournalEntry(
  title: title,
  note: 'Note for $title',
  createdAt: DateTime(2026, 1, 2),
  photoPath: photo,
);

void main() {
  testWidgets('empty journal shows the localized empty state', (tester) async {
    await pumpApp(tester);
    expect(find.byType(JournalCard), findsNothing);
    expect(
      find.text('No moments yet. Tap + to add your first entry.'),
      findsOneWidget,
    );
  });

  testWidgets('saved entries load, detail and settings navigation', (
    tester,
  ) async {
    await pumpApp(
      tester,
      repository: FakeJournalRepository([
        sample('Saved moment'),
        sample('Second'),
      ]),
    );
    expect(find.byType(JournalCard), findsNWidgets(2));
    expect(find.text('Created on Jan 2, 2026'), findsNWidgets(2));
    await tester.tap(find.text('Saved moment'));
    await tester.pumpAndSettle();
    expect(find.text('Detail'), findsOneWidget);
    expect(find.text('Note for Saved moment'), findsOneWidget);
    await back(tester);
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('About EduSnap'), findsOneWidget);
    expect(find.text('0 KB used'), findsOneWidget);
    await back(tester);
    expect(find.byType(JournalCard), findsNWidgets(2));
  });

  testWidgets('empty and whitespace title show dialog; entry is saved', (
    tester,
  ) async {
    final repo = FakeJournalRepository();
    await pumpApp(tester, repository: repo);
    await openAdd(tester);
    for (final title in ['', '   ']) {
      await tester.enterText(find.byKey(const ValueKey('title')), title);
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text('Title missing'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
    }
    await tester.enterText(
      find.byKey(const ValueKey('title')),
      '  New learning  ',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<JournalCard>(find.byType(JournalCard).first).entry.title,
      'New learning',
    );
    expect(repo.stored.single.title, 'New learning');
    await tester.tap(find.text('New learning'));
    await tester.pumpAndSettle();
    expect(find.text('No note added.'), findsOneWidget);
  });

  testWidgets('edit prefill, save, detail and list sync through system back', (
    tester,
  ) async {
    final repo = FakeJournalRepository([sample('My first moment')]);
    await pumpApp(tester, repository: repo);
    await tester.tap(find.text('My first moment'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Edit entry'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextFormField>(find.byKey(const ValueKey('title')))
          .controller!
          .text,
      'My first moment',
    );
    await tester.enterText(find.byKey(const ValueKey('title')), 'Edited title');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Edited title'), findsOneWidget);
    await back(tester);
    expect(find.text('Edited title'), findsOneWidget);
    expect(repo.stored.single.title, 'Edited title');
    expect(repo.stored.single.createdAt, DateTime(2026, 1, 2));
  });

  testWidgets('delete asks for confirmation and cancelling keeps entry', (
    tester,
  ) async {
    final repo = FakeJournalRepository([sample('Keep me')]);
    await pumpApp(tester, repository: repo);
    await tester.drag(find.byType(JournalCard), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Delete entry?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.byType(JournalCard), findsOneWidget);
    expect(repo.stored, hasLength(1));

    await tester.drag(find.byType(JournalCard), const Offset(-500, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(find.byType(JournalCard), findsNothing);
    expect(repo.stored, isEmpty);
  });

  testWidgets('language switch translates the UI and is saved', (tester) async {
    final settings = FakeSettingsRepository();
    await pumpApp(
      tester,
      repository: FakeJournalRepository([sample('Moment')]),
      settings: settings,
    );
    expect(find.text('Created on Jan 2, 2026'), findsOneWidget);
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('\u7e41\u9ad4\u4e2d\u6587'));
    await tester.pumpAndSettle();
    expect(settings.code, 'zh');
    expect(find.text('\u8a2d\u5b9a'), findsOneWidget);
    expect(find.text('\u5df2\u4f7f\u7528 0 KB'), findsOneWidget);
    // The back button label is localized too, so navigate by its tooltip.
    await tester.tap(find.byTooltip('\u8fd4\u56de'));
    await tester.pumpAndSettle();
    expect(find.text('2026\u5e741\u67082\u65e5 \u5efa\u7acb'), findsOneWidget);
  });

  testWidgets('a saved Chinese choice is used on the next launch', (
    tester,
  ) async {
    await pumpApp(
      tester,
      repository: FakeJournalRepository([sample('Moment')]),
      language: 'zh',
    );
    expect(find.text('2026\u5e741\u67082\u65e5 \u5efa\u7acb'), findsOneWidget);
    expect(find.byTooltip('\u65b0\u589e\u8a18\u9304'), findsOneWidget);
  });

  testWidgets('settings shows storage size and clears with two confirmations', (
    tester,
  ) async {
    final photos = FakePhotoStore()..files.addAll(['/photos/a.jpg']);
    final repo = FakeJournalRepository([
      sample('With photo', photo: '/photos/a.jpg'),
    ]);
    await pumpApp(tester, repository: repo, photos: photos);
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('2 KB used'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('clear-entries')));
    await tester.pumpAndSettle();
    expect(find.text('Clear all entries?'), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('Are you sure?'), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('0 KB used'), findsOneWidget);
    expect(repo.stored, isEmpty);
    expect(photos.files, isEmpty);
  });

  testWidgets('cancelling the second confirmation keeps entries', (
    tester,
  ) async {
    final repo = FakeJournalRepository([sample('Keep')]);
    await pumpApp(tester, repository: repo);
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('clear-entries')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(repo.stored, hasLength(1));
  });

  testWidgets('narrow layout still renders cards', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pumpApp(
      tester,
      repository: FakeJournalRepository([sample('Narrow')]),
    );
    expect(find.text('Narrow'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
