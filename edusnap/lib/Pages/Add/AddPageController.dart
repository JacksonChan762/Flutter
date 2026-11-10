// ignore_for_file: file_names
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

  /// Current photo shown on the form: the saved one until replaced.
  String? photoPath;
  bool get isEditing => entry != null;

  PhotoPickerService get pickerService => _pickerService;

  /// Picks a photo and copies it into app storage. Returns the pick status.
  Future<PhotoPickResult> pickPhoto(PhotoSource source) async {
    final result = await _pickerService.pick(source);
    if (result.status != PhotoPickStatus.picked || result.path == null) {
      return result;
    }
    final id = entry?.id ?? 'draft-${DateTime.now().microsecondsSinceEpoch}';
    final previous = photoPath;
    photoPath = await _photoStore.save(result.path!, id);
    if (previous != null && previous != photoPath) {
      await _photoStore.delete(previous);
    }
    return PhotoPickResult(PhotoPickStatus.picked, path: photoPath);
  }

  Future<void> removePhoto() async {
    final previous = photoPath;
    photoPath = null;
    await _photoStore.delete(previous);
  }

  JournalEntry? save() {
    final value = title.text.trim();
    if (value.isEmpty) return null;
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
    title.dispose();
    note.dispose();
  }
}
