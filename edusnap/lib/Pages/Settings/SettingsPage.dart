// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../Component/DuoLayout/duo_layout.dart';
import '../../Services/photo_store.dart';
import '../../l10n/app_localizations.dart';
import 'SettingsPageController.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.onLanguageChanged,
    required this.onClearAll,
    required this.referencedPhotoPaths,
    this.photoStore,
  });

  final ValueChanged<String> onLanguageChanged;
  final Future<void> Function() onClearAll;
  final Set<String> Function() referencedPhotoPaths;
  final PhotoStore? photoStore;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final SettingsPageController controller;
  late final Future<PackageInfo> _packageInfo = PackageInfo.fromPlatform();

  @override
  void initState() {
    super.initState();
    controller = SettingsPageController(photoStore: widget.photoStore)..load();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<bool> confirm(String title, String body) async {
    final l10n = AppLocalizations.of(context);
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(body),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.btnCancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.btnOk),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> selectLanguage(String code) async {
    await controller.changeLanguage(code);
    if (!mounted) return;
    widget.onLanguageChanged(code);
  }

  Future<void> formatStorage() async {
    final l10n = AppLocalizations.of(context);
    if (!await confirm(
      l10n.settingsFormatConfirmTitle,
      l10n.settingsFormatConfirmBody,
    )) {
      return;
    }
    if (!mounted) return;
    // Read after confirmation so cleanup uses the current journal state.
    await controller.formatStorage(widget.referencedPhotoPaths());
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.settingsFormatDone)));
  }

  Future<void> clearAll() async {
    final l10n = AppLocalizations.of(context);
    if (!await confirm(
      l10n.settingsClearConfirmTitle,
      l10n.settingsClearConfirmBody,
    )) {
      return;
    }
    if (!mounted) return;
    if (!await confirm(
      l10n.settingsClearFinalTitle,
      l10n.settingsClearFinalBody,
    )) {
      return;
    }
    await controller.clearAll(widget.onClearAll);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.settingsClearDone)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        automaticallyImplyLeading: !DuoLayoutScope.railActiveOf(context),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: DuoLayoutScope.contentWidthOf(context),
          ),
          child: ListenableBuilder(
            listenable: controller,
            builder: (context, _) => ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  l10n.settingsLanguageSection,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(
                      value: 'en',
                      label: Text(l10n.settingsLanguageEnglish),
                    ),
                    ButtonSegment(
                      value: 'zh',
                      label: Text(l10n.settingsLanguageChinese),
                    ),
                  ],
                  selected: {controller.languageCode ?? 'en'},
                  onSelectionChanged: (value) => selectLanguage(value.first),
                ),
                const Divider(height: 40),
                Text(
                  l10n.settingsStorageSection,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.settingsStorageUsed(formatBytes(controller.usedBytes)),
                  key: const ValueKey('storage-size'),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.settingsFormatHint,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      key: const ValueKey('format-storage'),
                      onPressed: formatStorage,
                      icon: const Icon(Icons.cleaning_services_outlined),
                      label: Text(l10n.settingsFormat),
                    ),
                    OutlinedButton.icon(
                      key: const ValueKey('clear-entries'),
                      onPressed: clearAll,
                      icon: const Icon(Icons.delete_forever_outlined),
                      label: Text(l10n.settingsClear),
                    ),
                  ],
                ),
                const Divider(height: 40),
                Text(
                  l10n.settingsAboutSection,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(l10n.settingsAboutBody),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/icon.png',
                      width: 48,
                      height: 48,
                    ),
                  ),
                  title: Text(l10n.settingsVersionTitle),
                  subtitle: FutureBuilder<PackageInfo>(
                    future: _packageInfo,
                    builder: (context, snapshot) {
                      final info = snapshot.data;
                      return Text(
                        info != null
                            ? l10n.settingsVersion(
                                info.version,
                                info.buildNumber,
                              )
                            : snapshot.hasError
                            ? l10n.settingsVersionUnavailable
                            : l10n.settingsVersionLoading,
                        key: const ValueKey('app-version'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
