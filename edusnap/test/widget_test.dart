import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edusnap/main.dart';
import 'package:edusnap/Component/JournalCard/journal_card.dart';

Future<void> openAdd(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Add entry'));
  await tester.pumpAndSettle();
}

Future<void> back(WidgetTester tester) async {
  await tester.pageBack();
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('three samples, detail and settings navigation', (tester) async {
    await tester.pumpWidget(const EduSnapApp());
    expect(find.byType(JournalCard), findsNWidgets(3));
    await tester.tap(find.text('My first learning moment'));
    await tester.pumpAndSettle();
    expect(find.text('Detail'), findsOneWidget);
    expect(
      find.text('Today I learned how Flutter widgets build a screen.'),
      findsOneWidget,
    );
    await back(tester);
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('About EduSnap'), findsOneWidget);
    await back(tester);
    expect(find.byType(JournalCard), findsNWidgets(3));
  });
  testWidgets(
    'empty and whitespace title show dialog; optional note; insert at top',
    (tester) async {
      await tester.pumpWidget(const EduSnapApp());
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
      await tester.tap(find.text('New learning'));
      await tester.pumpAndSettle();
      expect(find.text('No note added.'), findsOneWidget);
    },
  );
  testWidgets('edit prefill, save, detail and list sync through system back', (
    tester,
  ) async {
    await tester.pumpWidget(const EduSnapApp());
    await tester.tap(find.text('My first learning moment'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Edit entry'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextFormField>(find.byKey(const ValueKey('title')))
          .controller!
          .text,
      'My first learning moment',
    );
    expect(
      tester
          .widget<TextFormField>(find.byKey(const ValueKey('note')))
          .controller!
          .text,
      contains('Flutter widgets'),
    );
    await tester.enterText(find.byKey(const ValueKey('title')), 'Edited title');
    await tester.enterText(find.byKey(const ValueKey('note')), 'Edited note');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Edited title'), findsOneWidget);
    expect(find.text('Edited note'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Edited title'), findsOneWidget);
    expect(find.text('Edited note'), findsOneWidget);
    expect(find.byType(JournalCard), findsNWidgets(3));
  });
  testWidgets('cancel add and edit leave data unchanged', (tester) async {
    await tester.pumpWidget(const EduSnapApp());
    await openAdd(tester);
    await tester.enterText(find.byKey(const ValueKey('title')), 'Not saved');
    await back(tester);
    expect(find.text('Not saved'), findsNothing);
    await tester.tap(find.text('My first learning moment'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Edit entry'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('title')), 'Not saved');
    await back(tester);
    expect(find.text('My first learning moment'), findsOneWidget);
    await back(tester);
    expect(find.byType(JournalCard), findsNWidgets(3));
  });
  testWidgets('swipe cancel, confirm delete all and empty state', (
    tester,
  ) async {
    await tester.pumpWidget(const EduSnapApp());
    Future<void> swipe() async {
      await tester.drag(find.byType(Dismissible).first, const Offset(-700, 0));
      await tester.pumpAndSettle();
    }

    await swipe();
    expect(find.text('Delete entry?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.byType(JournalCard), findsNWidgets(3));
    for (var remaining = 2; remaining >= 0; remaining--) {
      await swipe();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      expect(find.byType(JournalCard), findsNWidgets(remaining));
    }
    expect(
      find.text('No moments yet. Tap + to add your first entry.'),
      findsOneWidget,
    );
  });
  testWidgets('narrow phone list, form, detail and settings fit', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const EduSnapApp());
    expect(tester.takeException(), isNull);
    await openAdd(tester);
    await tester.enterText(find.byKey(const ValueKey('title')), 'Small screen');
    expect(tester.takeException(), isNull);
    await back(tester);
    await tester.tap(find.text('My first learning moment'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await back(tester);
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
