/// Data only: no widgets, storage, or network calls.
class JournalEntry {
  final String id;
  final String title;
  final String note;
  final DateTime createdAt;

  const JournalEntry({
    required this.id,
    required this.title,
    required this.note,
    required this.createdAt,
  });
}
