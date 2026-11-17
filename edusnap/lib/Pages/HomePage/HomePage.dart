// ignore_for_file: file_names
import 'package:flutter/material.dart';

import '../../Component/JournalCard/journal_card.dart';
import '../../Component/DuoLayout/duo_layout.dart';
import '../../Models/JournalEntry.dart';
import '../../Services/journal_repository.dart';
import '../../Services/photo_store.dart';
import '../../l10n/app_localizations.dart';
import '../Add/AddPage.dart';
import '../Detail/DetailPage.dart';
import '../Settings/SettingsPage.dart';
import 'HomePageController.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.onLanguageChanged,
    this.repository,
    this.photoStore,
  });

  final ValueChanged<String> onLanguageChanged;
  final JournalRepository? repository;
  final PhotoStore? photoStore;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomePageController controller;
  @override
  void initState() {
    super.initState();
    controller = HomePageController(
      repository: widget.repository,
      photoStore: widget.photoStore,
    )..load();
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
    await controller.add(entry);
  }

  Future<void> openEntry(JournalEntry entry) async {
    final updated = await Navigator.of(context).push<JournalEntry>(
      MaterialPageRoute(
        builder: (_) => DetailPage(entry: entry, onUpdated: controller.update),
      ),
    );
    if (!mounted || updated == null) return;
    await controller.update(updated);
  }

  Future<bool> confirmDelete(JournalEntry entry) async {
    final l10n = AppLocalizations.of(context);
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.deleteDialogTitle),
            content: Text(l10n.deleteDialogBody(entry.title)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.btnCancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.btnDelete),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> openSettings() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => SettingsPage(
          onLanguageChanged: widget.onLanguageChanged,
          onClearAll: controller.clearAll,
          photoStore: widget.photoStore,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: l10n.homeSettingsTooltip,
          icon: const Icon(Icons.settings_outlined),
          onPressed: openSettings,
        ),
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            tooltip: l10n.homeAddTooltip,
            onPressed: addEntry,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: DuoLayoutScope.contentWidthOf(context),
          ),
          child: ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              if (!controller.isLoaded) {
                return const Center(child: CircularProgressIndicator());
              }
              final entries = controller.entries;
              if (entries.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(l10n.homeEmpty, textAlign: TextAlign.center),
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
}
