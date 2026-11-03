// ignore_for_file: file_names
import 'package:flutter/material.dart';

import '../../Models/JournalEntry.dart';
import 'AddPageController.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key, this.entry});
  final JournalEntry? entry;
  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  late final AddPageController controller;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    controller = AddPageController(entry: widget.entry);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Title missing'),
          content: const Text('Please enter a title before saving.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
    final entry = controller.save();
    if (entry != null && mounted) Navigator.pop(context, entry);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(controller.isEditing ? 'Edit entry' : 'Add entry'),
    ),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              TextFormField(
                key: const ValueKey('title'),
                controller: controller.title,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'What did you learn?',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Title is required'
                    : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                key: const ValueKey('note'),
                controller: controller.note,
                decoration: const InputDecoration(
                  labelText: 'Note (optional)',
                  border: OutlineInputBorder(),
                ),
                minLines: 4,
                maxLines: 8,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: save,
                icon: const Icon(Icons.check),
                label: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
