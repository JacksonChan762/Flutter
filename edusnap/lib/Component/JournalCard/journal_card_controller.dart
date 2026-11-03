import '../../Models/journal_entry.dart';
import '../../Utils/date_formatter.dart';

/// Presentation adapter shared by journal cards. No page-specific state.
class JournalCardController {
  final JournalEntry entry;
  const JournalCardController(this.entry);
  String get dateLabel => formatJournalDate(entry.createdAt);
}
