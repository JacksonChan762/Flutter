import 'package:flutter_test/flutter_test.dart';
import 'package:edusnap/Pages/JournalList/journal_list_page_controller.dart';
import 'package:edusnap/Utils/date_formatter.dart';

void main() {
  test('controller owns demo data and notifies listeners', () {
    final controller = JournalListPageController();
    addTearDown(controller.dispose);
    var notifications = 0;
    controller.addListener(() => notifications++);
    expect(controller.entries, isEmpty);
    controller.loadDemo();
    controller.loadDemo();
    expect(controller.entries, hasLength(1));
    expect(() => controller.entries.clear(), throwsUnsupportedError);
    controller.clear();
    expect(controller.entries, isEmpty);
    expect(notifications, 3);
  });
  test('dates are zero padded', () {
    expect(formatJournalDate(DateTime(2026, 1, 2)), '2026-01-02');
  });
}
