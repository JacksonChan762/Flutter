import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../Models/JournalEntry.dart';

/// Persists the journal list as one JSON string in shared preferences.
class JournalRepository {
  static const entriesKey = 'journal_entries_v1';

  Future<List<JournalEntry>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(entriesKey);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return decoded
          .map(JournalEntry.fromJson)
          .whereType<JournalEntry>()
          .toList();
    } on FormatException {
      return const [];
    }
  }

  Future<void> save(List<JournalEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      entriesKey,
      jsonEncode(entries.map((entry) => entry.toJson()).toList()),
    );
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(entriesKey);
  }
}
