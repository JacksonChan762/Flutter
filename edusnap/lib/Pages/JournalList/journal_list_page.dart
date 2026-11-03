import 'package:flutter/material.dart';

import '../../Component/JournalCard/journal_card.dart';
import 'journal_list_page_controller.dart';

class JournalListPage extends StatefulWidget {
  const JournalListPage({super.key});
  @override
  State<JournalListPage> createState() => _JournalListPageState();
}

class _JournalListPageState extends State<JournalListPage> {
  late final JournalListPageController controller;

  @override
  void initState() {
    super.initState();
    controller = JournalListPageController()..loadDemo();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('EduSnap')),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) => ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                'Your learning journal',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              const Text('Session 1 · MVC starter · In-memory demo'),
              const SizedBox(height: 24),
              if (controller.entries.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Text('No moments yet. Load the demo to get started.'),
                ),
              ...controller.entries.map((entry) => JournalCard(entry: entry)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  FilledButton.icon(
                    onPressed: controller.loadDemo,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Load demo'),
                  ),
                  OutlinedButton.icon(
                    onPressed: controller.clear,
                    icon: const Icon(Icons.clear_all),
                    label: const Text('Clear demo'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Coming in later sessions: add and detail screens, '
                'photos, local storage, and language settings.',
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
