import 'package:edusnap/Models/JournalEntry.dart';
import 'package:edusnap/Services/journal_repository.dart';
import 'package:edusnap/Services/photo_store.dart';
import 'package:edusnap/Services/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// In-memory stand-in for the JSON-backed repository.
class FakeJournalRepository implements JournalRepository {
  FakeJournalRepository([List<JournalEntry>? seed])
    : stored = List.of(seed ?? const <JournalEntry>[]);
  List<JournalEntry> stored;
  int saveCount = 0;

  @override
  Future<List<JournalEntry>> load() async => List.of(stored);

  @override
  Future<void> save(List<JournalEntry> entries) async {
    stored = List.of(entries);
    saveCount++;
  }

  @override
  Future<void> clear() async {
    stored = [];
  }
}

/// Records photo paths without touching the file system.
class FakePhotoStore implements PhotoStore {
  final Set<String> files = {};
  int saved = 0;

  @override
  Future<String> save(String sourcePath, String entryId) async {
    saved++;
    final path = '/photos/$entryId-$saved.jpg';
    files.add(path);
    return path;
  }

  @override
  Future<void> delete(String? path) async {
    if (path != null) files.remove(path);
  }

  @override
  Future<int> deleteUnused(Set<String> keep) async {
    final removed = files.where((path) => !keep.contains(path)).toList();
    files.removeAll(removed);
    return removed.length;
  }

  @override
  Future<int> usedBytes() async => files.length * 2048;
}

class FakeSettingsRepository implements SettingsRepository {
  FakeSettingsRepository([this.code]);
  String? code;

  @override
  Future<String?> loadLanguageCode() async => code;

  @override
  Future<void> saveLanguageCode(String value) async => code = value;
}

/// Clears shared preferences so tests never see another test's journal.
void useEmptyPreferences() {
  SharedPreferences.setMockInitialValues({});
}
