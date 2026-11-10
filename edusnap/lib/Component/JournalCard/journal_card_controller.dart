import '../../Models/JournalEntry.dart';
import '../../Utils/date_formatter.dart';
import '../../l10n/app_localizations.dart';

/// Presentation adapter shared by journal cards. No page-specific state.
class JournalCardController {
  final JournalEntry entry;
  const JournalCardController(this.entry);

  String? get photoPath => entry.photoPath;

  /// Localized "Created on {date}" label using the ARB placeholder.
  String dateLabel(AppLocalizations l10n, {String? localeName}) => l10n
      .createdOn(formatJournalDate(entry.createdAt, localeName: localeName));
}
