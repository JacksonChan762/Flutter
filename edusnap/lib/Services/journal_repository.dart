import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../Models/JournalEntry.dart';

/// Persists the journal list as one JSON string in shared preferences.
class JournalRepository {
  static const entriesKey = 'journal_entries_v1';

  Future<List<JournalEntry>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(entriesKey);
    if (raw == null) {
      final samples = [
        JournalEntry(
          title: 'Welcome to EduSnap',
          note: 'Tap a card to view it, then use Edit to make it your own.',
          createdAt: DateTime(2026, 1, 1),
        ),
        JournalEntry(
          title: 'A moment of learning',
          note: 'Use + to add a title, a note and a photo.',
          createdAt: DateTime(2026, 1, 2),
        ),
        JournalEntry(
          title: 'Make it yours',
          note: 'Switch language in Settings, or swipe left to delete this sample.',
          createdAt: DateTime(2026, 1, 3),
        ),
      ];
      await save(samples);
      return samples;
    }
    if (raw.isEmpty) return const [];
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
    // Retain an initialized empty list so clearing never brings samples back.
    await prefs.setString(entriesKey, '[]');
  }
}
