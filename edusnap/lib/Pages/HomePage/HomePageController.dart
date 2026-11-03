// ignore_for_file: file_names
import 'package:flutter/foundation.dart';

import '../../Models/JournalEntry.dart';

class HomePageController extends ChangeNotifier {
  final List<JournalEntry> _entries = [];
  List<JournalEntry> get entries => List.unmodifiable(_entries);

  void loadSamples() {
    if (_entries.isNotEmpty) return;
    final now = DateTime.now();
    _entries.addAll([
      JournalEntry(
        title: 'My first learning moment',
        note: 'Today I learned how Flutter widgets build a screen.',
        createdAt: now,
      ),
      JournalEntry(
        title: 'A little curiosity',
        note: 'What is the difference between push and pop?',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      JournalEntry(
        title: 'Practice makes progress',
        note: 'I created my first journal model and reusable card.',
        createdAt: now.subtract(const Duration(days: 2)),
      ),
    ]);
    notifyListeners();
  }

  void add(JournalEntry entry) {
    _entries.insert(0, entry);
    notifyListeners();
  }

  void update(JournalEntry entry) {
    final index = _entries.indexWhere((item) => item.id == entry.id);
    if (index < 0) return;
    _entries[index] = entry;
    notifyListeners();
  }

  void remove(JournalEntry entry) {
    _entries.removeWhere((item) => item.id == entry.id);
    notifyListeners();
  }
}
