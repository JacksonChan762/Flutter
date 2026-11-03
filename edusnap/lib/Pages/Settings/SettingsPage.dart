// ignore_for_file: file_names
import 'package:flutter/material.dart';

import 'SettingsPageController.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = SettingsPageController();
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                'About EduSnap',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Text(controller.storageNotice),
              const SizedBox(height: 16),
              Text(controller.futureFeatures),
            ],
          ),
        ),
      ),
    );
  }
}
