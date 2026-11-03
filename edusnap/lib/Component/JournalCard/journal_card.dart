import 'package:flutter/material.dart';

import '../../Models/JournalEntry.dart';
import 'journal_card_controller.dart';

class JournalCard extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback? onTap;
  const JournalCard({super.key, required this.entry, this.onTap});

  @override
  Widget build(BuildContext context) {
    final presenter = JournalCardController(entry);
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.auto_stories_outlined, size: 40),
              const SizedBox(height: 16),
              Text(entry.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(entry.note),
              const SizedBox(height: 16),
              Text(presenter.dateLabel),
            ],
          ),
        ),
      ),
    );
  }
}
