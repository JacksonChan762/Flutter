// ignore_for_file: file_names
import 'dart:io';

import 'package:flutter/material.dart';

import '../../Models/JournalEntry.dart';
import '../../Component/DuoLayout/duo_layout.dart';
import '../../Utils/date_formatter.dart';
import '../../l10n/app_localizations.dart';
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !DuoLayoutScope.railActiveOf(context),
        title: Text(l10n.detailTitle),
        actions: [
          IconButton(
            tooltip: l10n.detailEditTooltip,
            onPressed: edit,
            icon: const Icon(Icons.edit_outlined),
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
              final entry = controller.entry;
              final photoPath = entry.photoPath;
              return ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  if (photoPath != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(photoPath),
                          key: const ValueKey('detail-photo'),
                          height: 240,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  Text(
                    entry.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.createdOn(
                      formatJournalDate(
                        entry.createdAt,
                        localeName: Localizations.localeOf(context).toString(),
                      ),
                    ),
                  ),
                  const Divider(height: 40),
                  Text(entry.note.isEmpty ? l10n.detailNoNote : entry.note),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
