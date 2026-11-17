// ignore_for_file: file_names
import 'dart:async';

import 'package:flutter/material.dart';

import '../../Models/JournalEntry.dart';
import '../../Services/photo_picker_service.dart';
import '../../Services/photo_store.dart';

class AddPageController {
  AddPageController({
    this.entry,
    PhotoPickerService? pickerService,
    PhotoStore? photoStore,
  }) : title = TextEditingController(text: entry?.title ?? ''),
       note = TextEditingController(text: entry?.note ?? ''),
       photoPath = entry?.photoPath,
       _pickerService = pickerService ?? PhotoPickerService(),
       _photoStore = photoStore ?? PhotoStore();

  final JournalEntry? entry;
  final TextEditingController title;
  final TextEditingController note;
  final PhotoPickerService _pickerService;
  final PhotoStore _photoStore;
  final Set<String> _draftPhotos = {};
  bool _disposed = false;
  bool _picking = false;
  bool get isPicking => _picking;

  /// Current photo shown on the form: the saved one until replaced.
  String? photoPath;
  bool get isEditing => entry != null;

  PhotoPickerService get pickerService => _pickerService;

  /// Picks a photo and copies it into app storage. Returns the pick status.
  Future<PhotoPickResult> pickPhoto(PhotoSource source) async {
    if (_disposed || _picking) {
      return const PhotoPickResult(PhotoPickStatus.cancelled);
    }
    _picking = true;
    try {
      final result = await _pickerService.pick(source);
      if (_disposed) return const PhotoPickResult(PhotoPickStatus.cancelled);
      if (result.status != PhotoPickStatus.picked || result.path == null) {
        return result;
      }
      final id = entry?.id ?? 'draft-${DateTime.now().microsecondsSinceEpoch}';
      final copied = await _photoStore.save(result.path!, id);
      if (_disposed) {
        await _photoStore.delete(copied);
        return const PhotoPickResult(PhotoPickStatus.cancelled);
      }
      final previous = photoPath;
      _draftPhotos.add(copied);
      photoPath = copied;
      await _deleteDraft(previous);
      return PhotoPickResult(PhotoPickStatus.picked, path: photoPath);
    } catch (_) {
      return const PhotoPickResult(PhotoPickStatus.failed);
    } finally {
      _picking = false;
    }
  }

  Future<void> removePhoto() async {
    final previous = photoPath;
    photoPath = null;
    await _deleteDraft(previous);
  }

  Future<void> _deleteDraft(String? path) async {
    if (path != null && _draftPhotos.remove(path)) {
      await _photoStore.delete(path);
    }
  }

  JournalEntry? save() {
    final value = title.text.trim();
    if (value.isEmpty || _picking || _disposed) return null;
    // Ownership passes to the journal; disposal only removes uncommitted files.
    _draftPhotos.remove(photoPath);
    return entry?.copyWith(
          title: value,
          note: note.text.trim(),
          photoPath: photoPath,
          clearPhoto: photoPath == null,
        ) ??
        JournalEntry(
          title: value,
          note: note.text.trim(),
          createdAt: DateTime.now(),
          photoPath: photoPath,
        );
  }

  void dispose() {
    _disposed = true;
    for (final path in _draftPhotos.toList()) {
      unawaited(_deleteDraft(path));
    }
    title.dispose();
    note.dispose();
  }
}
