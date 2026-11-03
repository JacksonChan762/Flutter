import 'package:flutter_test/flutter_test.dart';
import 'package:edusnap/Models/JournalEntry.dart';
import 'package:edusnap/Pages/HomePage/HomePageController.dart';
import 'package:edusnap/Pages/Add/AddPageController.dart';
import 'package:edusnap/Utils/date_formatter.dart';

void main() {
  test('samples, immutable list, insert, update and remove notify', () {
    final c = HomePageController();
    addTearDown(c.dispose);
    var notifications = 0;
    c.addListener(() => notifications++);
    c.loadSamples();
    expect(c.entries, hasLength(3));
    expect(c.entries.map((e) => e.id).toSet(), hasLength(3));
    expect(() => c.entries.clear(), throwsUnsupportedError);
    final entry = JournalEntry(
      title: 'New',
      note: '',
      createdAt: DateTime(2026),
    );
    c.add(entry);
    expect(c.entries.first, entry);
    final edited = entry.copyWith(title: 'Updated');
    c.update(edited);
    expect(c.entries.first.title, 'Updated');
    expect(c.entries.first.createdAt, entry.createdAt);
    expect(c.entries, hasLength(4));
    c.remove(edited);
    expect(c.entries, hasLength(3));
    expect(notifications, 4);
  });
  test('add trims title, rejects whitespace, note is optional', () {
    final c = AddPageController();
    addTearDown(c.dispose);
    c.title.text = '   ';
    expect(c.save(), isNull);
    c.title.text = '  Hello  ';
    expect(c.save()!.title, 'Hello');
    expect(c.save()!.note, isEmpty);
  });
  test('edit preserves identity and createdAt without mutating original', () {
    final original = JournalEntry(
      title: 'Before',
      note: 'Note',
      createdAt: DateTime(2026, 1, 2),
    );
    final c = AddPageController(entry: original);
    addTearDown(c.dispose);
    expect(c.title.text, 'Before');
    expect(c.note.text, 'Note');
    c.title.text = 'After';
    final result = c.save()!;
    expect(result.id, original.id);
    expect(result.createdAt, original.createdAt);
    expect(original.title, 'Before');
    expect(result.title, 'After');
  });
  test('dates are zero padded', () {
    expect(formatJournalDate(DateTime(2026, 1, 2)), '2026-01-02');
  });
}
