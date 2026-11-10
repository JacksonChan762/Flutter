import 'package:intl/intl.dart';

/// Display formatter for entry dates. Storage keeps ISO-8601 strings.
/// [localeName] comes from Localizations.localeOf(context).toString().
String formatJournalDate(DateTime date, {String? localeName}) =>
    DateFormat.yMMMd(localeName).format(date);
