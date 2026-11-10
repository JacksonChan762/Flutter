import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Owns the folder where entry photos are copied. Photos live outside the
/// cache so they survive app restarts.
class PhotoStore {
  static const folderName = 'entry_photos';

  Future<Directory> _folder() async {
    final base = await getApplicationDocumentsDirectory();
    final folder = Directory('${base.path}/$folderName');
    if (!await folder.exists()) await folder.create(recursive: true);
    return folder;
  }

  /// Copies a picked image into app storage and returns the new path.
  Future<String> save(String sourcePath, String entryId) async {
    final folder = await _folder();
    final extension = _extensionOf(sourcePath);
    final target = File('${folder.path}/$entryId$extension');
    if (target.existsSync()) await target.delete();
    await File(sourcePath).copy(target.path);
    return target.path;
  }

  Future<void> delete(String? path) async {
    if (path == null || path.isEmpty) return;
    final file = File(path);
    if (await file.exists()) await file.delete();
  }

  /// Deletes every stored photo that is not referenced by [keep].
  Future<int> deleteUnused(Set<String> keep) async {
    final folder = await _folder();
    var removed = 0;
    await for (final entity in folder.list()) {
      if (entity is! File) continue;
      if (keep.contains(entity.path)) continue;
      await entity.delete();
      removed++;
    }
    return removed;
  }

  /// Total bytes used by stored photos.
  Future<int> usedBytes() async {
    final folder = await _folder();
    var total = 0;
    await for (final entity in folder.list()) {
      if (entity is File) total += await entity.length();
    }
    return total;
  }

  static String _extensionOf(String path) {
    final name = path.split('/').last;
    final dot = name.lastIndexOf('.');
    if (dot <= 0) return '.jpg';
    final extension = name.substring(dot).toLowerCase();
    return extension.length > 5 ? '.jpg' : extension;
  }
}
