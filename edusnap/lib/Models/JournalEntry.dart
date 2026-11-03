// ignore_for_file: file_names
/// Immutable data only. Identity and creation time survive edits.
class JournalEntry {
  final String id;
  final String title;
  final String note;
  final DateTime createdAt;

  JournalEntry({
    String? id,
    required this.title,
    required this.note,
    required this.createdAt,
  }) : id = id ?? 'entry-${_nextId++}';
  static int _nextId = 0;

  JournalEntry copyWith({String? title, String? note}) => JournalEntry(
    id: id,
    title: title ?? this.title,
    note: note ?? this.note,
    createdAt: createdAt,
  );
}
