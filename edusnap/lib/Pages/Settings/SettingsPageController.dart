// ignore_for_file: file_names
import 'package:flutter/foundation.dart';

import '../../Services/photo_store.dart';
import '../../Services/settings_repository.dart';

/// Settings state: saved language plus the local photo storage size.
class SettingsPageController extends ChangeNotifier {
  SettingsPageController({
    PhotoStore? photoStore,
    SettingsRepository? settingsRepository,
  }) : _photoStore = photoStore ?? PhotoStore(),
       _settingsRepository = settingsRepository ?? SettingsRepository();

  final PhotoStore _photoStore;
  final SettingsRepository _settingsRepository;

  String? _languageCode;
  String? get languageCode => _languageCode;

  int _usedBytes = 0;
  int get usedBytes => _usedBytes;

  Future<void> load() async {
    _languageCode = await _settingsRepository.loadLanguageCode();
    await refreshSize();
  }

  Future<void> refreshSize() async {
    _usedBytes = await _photoStore.usedBytes();
    notifyListeners();
  }

  Future<void> changeLanguage(String code) async {
    _languageCode = code;
    await _settingsRepository.saveLanguageCode(code);
    notifyListeners();
  }

  /// Deletes stored photos not listed in [keep], then refreshes the size.
  Future<int> formatStorage(Set<String> keep) async {
    final removed = await _photoStore.deleteUnused(keep);
    await refreshSize();
    return removed;
  }

  /// Clears every entry (which also deletes their photos) plus any leftover
  /// photo file, then refreshes the displayed size.
  Future<void> clearAll(Future<void> Function() clearEntries) async {
    await clearEntries();
    await _photoStore.deleteUnused(const <String>{});
    await refreshSize();
  }
}

/// Human readable size, e.g. 0 KB, 512 KB, 1.2 MB.
String formatBytes(int bytes) {
  if (bytes < 1024) return '0 KB';
  final kb = bytes / 1024;
  if (kb < 1024) return '${kb.toStringAsFixed(0)} KB';
  final mb = kb / 1024;
  return '${mb.toStringAsFixed(1)} MB';
}
