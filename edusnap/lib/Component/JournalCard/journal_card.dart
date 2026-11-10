import 'dart:io';

import 'package:flutter/material.dart';

import '../../Models/JournalEntry.dart';
import '../../l10n/app_localizations.dart';
import 'journal_card_controller.dart';

class JournalCard extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback? onTap;
  const JournalCard({super.key, required this.entry, this.onTap});

  @override
  Widget build(BuildContext context) {
    final presenter = JournalCardController(entry);
    final photoPath = presenter.photoPath;
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: photoPath == null
                      ? const _PhotoPlaceholder()
                      : Image.file(
                          File(photoPath),
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const _PhotoPlaceholder(),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    if (entry.note.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        entry.note,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 12),
                    Text(
                      presenter.dateLabel(
                        AppLocalizations.of(context),
                        localeName: Localizations.localeOf(context).toString(),
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder();

  @override
  Widget build(BuildContext context) => Container(
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    child: const Icon(Icons.photo_outlined),
  );
}
