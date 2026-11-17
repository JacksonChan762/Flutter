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
  bool _disposed = false;
  Future<void> _pendingSave = Future<void>.value();

  List<JournalEntry> get entries => List.unmodifiable(_entries);
  bool get isLoaded => _loaded;

  /// Reads the saved journal once. An empty store keeps an empty journal.
  Future<void> load() async {
    final stored = await _repository.load();
    _entries
      ..clear()
      ..addAll(stored);
    _loaded = true;
    _notify();
  }

  Future<void> add(JournalEntry entry) async {
    _entries.insert(0, entry);
    _notify();
    await _persist();
  }

  Future<void> update(JournalEntry entry) async {
    final index = _entries.indexWhere((item) => item.id == entry.id);
    if (index < 0) return;
    final previous = _entries[index];
    _entries[index] = entry;
    _notify();
    await _persist();
    if (previous.photoPath != entry.photoPath) {
      await _photoStore.delete(previous.photoPath);
    }
  }

  Future<void> remove(JournalEntry entry) async {
    _entries.removeWhere((item) => item.id == entry.id);
    _notify();
    await _persist();
    await _photoStore.delete(entry.photoPath);
  }

  /// Deletes every entry and its photo, then clears the stored list.
  Future<void> clearAll() async {
    final removed = List<JournalEntry>.of(_entries);
    _entries.clear();
    _notify();
    await _persist();
    for (final entry in removed) {
      await _photoStore.delete(entry.photoPath);
    }
  }

  /// Also called when the app becomes inactive or enters the background.
  Future<void> save() => _loaded ? _persist() : Future<void>.value();

  Future<void> _persist() {
    final snapshot = List<JournalEntry>.of(_entries);
    final write = _pendingSave.then((_) => _repository.save(snapshot));
    // Preserve ordering without letting one failure block future writes.
    _pendingSave = write.catchError((Object error) {});
    return write;
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
