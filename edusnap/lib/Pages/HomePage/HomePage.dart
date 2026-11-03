// ignore_for_file: file_names
import 'package:flutter/material.dart';

import '../../Component/JournalCard/journal_card.dart';
import '../../Models/JournalEntry.dart';
import '../Add/AddPage.dart';
import '../Detail/DetailPage.dart';
import '../Settings/SettingsPage.dart';
import 'HomePageController.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomePageController controller;
  @override
  void initState() {
    super.initState();
    controller = HomePageController()..loadSamples();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> addEntry() async {
    final entry = await Navigator.of(context)
        .push<JournalEntry>(MaterialPageRoute(builder: (_) => const AddPage()));
    if (!mounted || entry == null) return;
    controller.add(entry);
  }

  Future<void> openEntry(JournalEntry entry) async {
    final updated = await Navigator.of(context).push<JournalEntry>(
      MaterialPageRoute(
        builder: (_) => DetailPage(entry: entry, onUpdated: controller.update),
      ),
    );
    if (!mounted || updated == null) return;
    controller.update(updated);
  }

  Future<bool> confirmDelete(JournalEntry entry) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete entry?'),
          content: Text('Delete “${entry.title}”? This cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        ),
      ) ??
      false;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        tooltip: 'Settings',
        icon: const Icon(Icons.settings_outlined),
        onPressed: () => Navigator.of(
          context,
        ).push<void>(MaterialPageRoute(builder: (_) => const SettingsPage())),
      ),
      title: const Text('EduSnap'),
      actions: [
        IconButton(
          tooltip: 'Add entry',
          onPressed: addEntry,
          icon: const Icon(Icons.add),
        ),
      ],
    ),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            final entries = controller.entries;
            if (entries.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('No moments yet. Tap + to add your first entry.'),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return Dismissible(
                  key: ValueKey(entry.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.all(24),
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: const Icon(Icons.delete_outline),
                  ),
                  confirmDismiss: (_) => confirmDelete(entry),
                  onDismissed: (_) => controller.remove(entry),
                  child: JournalCard(
                    entry: entry,
                    onTap: () => openEntry(entry),
                  ),
                );
              },
            );
          },
        ),
      ),
    ),
  );
}
