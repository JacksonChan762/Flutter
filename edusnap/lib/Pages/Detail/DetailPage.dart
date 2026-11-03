// ignore_for_file: file_names
import 'package:flutter/material.dart';

import '../../Models/JournalEntry.dart';
import '../../Utils/date_formatter.dart';
import '../Add/AddPage.dart';
import 'DetailPageController.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.entry, required this.onUpdated});
  final JournalEntry entry;
  final ValueChanged<JournalEntry> onUpdated;
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late final DetailPageController controller;
  @override
  void initState() {
    super.initState();
    controller = DetailPageController(widget.entry);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> edit() async {
    final entry = await Navigator.of(context).push<JournalEntry>(
      MaterialPageRoute(builder: (_) => AddPage(entry: controller.entry)),
    );
    if (!mounted || entry == null) return;
    controller.update(entry);
    // Sync List immediately, including when system back or a back gesture is used.
    widget.onUpdated(entry);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Detail'),
      actions: [
        IconButton(
          tooltip: 'Edit entry',
          onPressed: edit,
          icon: const Icon(Icons.edit_outlined),
        ),
      ],
    ),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) => ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                controller.entry.title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(formatJournalDate(controller.entry.createdAt)),
              const Divider(height: 40),
              Text(
                controller.entry.note.isEmpty
                    ? 'No note added.'
                    : controller.entry.note,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
