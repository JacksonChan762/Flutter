// ignore_for_file: file_names
import 'package:flutter/material.dart';

import '../../Models/JournalEntry.dart';

class AddPageController {
  AddPageController({this.entry})
    : title = TextEditingController(text: entry?.title ?? ''),
      note = TextEditingController(text: entry?.note ?? '');
  final JournalEntry? entry;
  final TextEditingController title;
  final TextEditingController note;
  bool get isEditing => entry != null;
  JournalEntry? save() {
    final value = title.text.trim();
    if (value.isEmpty) return null;
    return entry?.copyWith(title: value, note: note.text.trim()) ??
        JournalEntry(
          title: value,
          note: note.text.trim(),
          createdAt: DateTime.now(),
        );
  }

  void dispose() {
    title.dispose();
    note.dispose();
  }
}
