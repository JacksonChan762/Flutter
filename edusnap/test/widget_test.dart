import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edusnap/main.dart';

void main() {
  testWidgets('welcome demo can be cleared and reloaded', (tester) async {
    await tester.pumpWidget(const EduSnapApp());
    expect(find.text('EduSnap'), findsOneWidget);
    expect(find.text('My first learning moment'), findsOneWidget);
    await tester.tap(find.text('Clear demo'));
    await tester.pump();
    expect(find.text('My first learning moment'), findsNothing);
    expect(
      find.text('No moments yet. Load the demo to get started.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Load demo'));
    await tester.pump();
    expect(find.text('My first learning moment'), findsOneWidget);
  });

  testWidgets('starter fits a narrow phone screen', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const EduSnapApp());
    expect(tester.takeException(), isNull);
  });
}
