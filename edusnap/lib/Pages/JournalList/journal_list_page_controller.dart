import 'package:flutter/foundation.dart';

import '../../Models/journal_entry.dart';

/// Owns the page data and actions, independently of the view.
class JournalListPageController extends ChangeNotifier {
  final List<JournalEntry> _entries = [];
  List<JournalEntry> get entries => List.unmodifiable(_entries);

  void loadDemo() {
    _entries
      ..clear()
      ..add(
        JournalEntry(
          id: 'welcome',
          title: 'My first learning moment',
          note:
              'EduSnap is ready! Capture what you learn, one moment at a time.',
          createdAt: DateTime(2026, 1, 1),
        ),
      );
    notifyListeners();
  }

  void clear() {
    _entries.clear();
    notifyListeners();
  }
}
