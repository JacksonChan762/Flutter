// ignore_for_file: file_names
import 'package:flutter/foundation.dart';

import '../../Models/JournalEntry.dart';
import '../../Services/journal_repository.dart';
import '../../Services/photo_store.dart';

class HomePageController extends ChangeNotifier {
  HomePageController({JournalRepository? repository, PhotoStore? photoStore})
    : _repository = repository ?? JournalRepository(),
      _photoStore = photoStore ?? PhotoStore();

  final JournalRepository _repository;
  final PhotoStore _photoStore;
  final List<JournalEntry> _entries = [];
  bool _loaded = false;

  List<JournalEntry> get entries => List.unmodifiable(_entries);
  bool get isLoaded => _loaded;

  /// Reads the saved journal once. An empty store keeps an empty journal.
  Future<void> load() async {
    final stored = await _repository.load();
    _entries
      ..clear()
      ..addAll(stored);
    _loaded = true;
    notifyListeners();
  }

  Future<void> add(JournalEntry entry) async {
    _entries.insert(0, entry);
    notifyListeners();
    await _persist();
  }

  Future<void> update(JournalEntry entry) async {
    final index = _entries.indexWhere((item) => item.id == entry.id);
    if (index < 0) return;
    final previous = _entries[index];
    _entries[index] = entry;
    notifyListeners();
    if (previous.photoPath != entry.photoPath) {
      await _photoStore.delete(previous.photoPath);
    }
    await _persist();
  }

  Future<void> remove(JournalEntry entry) async {
    _entries.removeWhere((item) => item.id == entry.id);
    notifyListeners();
    await _photoStore.delete(entry.photoPath);
    await _persist();
  }

  /// Deletes every entry and its photo, then clears the stored list.
  Future<void> clearAll() async {
    for (final entry in _entries) {
      await _photoStore.delete(entry.photoPath);
    }
    _entries.clear();
    notifyListeners();
    await _repository.clear();
  }

  Future<void> _persist() => _repository.save(_entries);
}
