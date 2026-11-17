// ignore_for_file: file_names
import 'dart:io';

import 'package:flutter/material.dart';

import '../../Models/JournalEntry.dart';
import '../../Component/DuoLayout/duo_layout.dart';
import '../../Services/photo_picker_service.dart';
import '../../l10n/app_localizations.dart';
import 'AddPageController.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key, this.entry, this.controller});
  final JournalEntry? entry;
  final AddPageController? controller;
  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  late final AddPageController controller;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? AddPageController(entry: widget.entry);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> save() async {
    final l10n = AppLocalizations.of(context);
    if (!formKey.currentState!.validate()) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.titleMissingTitle),
          content: Text(l10n.titleMissingBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.btnOk),
            ),
          ],
        ),
      );
      return;
    }
    final entry = controller.save();
    if (entry != null && mounted) Navigator.pop(context, entry);
  }

  Future<void> choosePhoto() async {
    final l10n = AppLocalizations.of(context);
    final source = await showModalBottomSheet<PhotoSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l10n.photoCamera),
              onTap: () => Navigator.pop(context, PhotoSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.photoGallery),
              onTap: () => Navigator.pop(context, PhotoSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;
    final picking = controller.pickPhoto(source);
    setState(() {});
    final result = await picking;
    if (!mounted) return;
    setState(() {});
    final sourceLabel = source == PhotoSource.camera
        ? l10n.photoSourceCamera
        : l10n.photoSourceGallery;
    switch (result.status) {
      case PhotoPickStatus.cancelled:
        break;
      case PhotoPickStatus.picked:
        setState(() {});
      case PhotoPickStatus.denied:
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.photoPermissionTitle),
            content: Text(l10n.photoPermissionBody(sourceLabel)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.btnCancel),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  controller.pickerService.openSettings();
                },
                child: Text(l10n.photoPermissionOpenSettings),
              ),
            ],
          ),
        );
      case PhotoPickStatus.failed:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.photoFailed(sourceLabel))));
    }
  }

  Future<void> removePhoto() async {
    await controller.removePhoto();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final photoPath = controller.photoPath;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !DuoLayoutScope.railActiveOf(context),
        title: Text(controller.isEditing ? l10n.editTitle : l10n.addTitle),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: DuoLayoutScope.contentWidthOf(context),
          ),
          child: Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                TextFormField(
                  key: const ValueKey('title'),
                  controller: controller.title,
                  decoration: InputDecoration(
                    labelText: l10n.fieldTitle,
                    hintText: l10n.fieldTitleHint,
                    border: const OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? l10n.fieldTitleRequired
                      : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  key: const ValueKey('note'),
                  controller: controller.note,
                  decoration: InputDecoration(
                    labelText: l10n.fieldNote,
                    border: const OutlineInputBorder(),
                  ),
                  minLines: 4,
                  maxLines: 8,
                ),
                const SizedBox(height: 20),
                _PhotoField(
                  photoPath: photoPath,
                  onPick: controller.isPicking ? null : choosePhoto,
                  onRemove: controller.isPicking ? null : removePhoto,
                  addLabel: photoPath == null
                      ? l10n.photoAdd
                      : l10n.photoChange,
                  removeLabel: l10n.photoRemove,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: controller.isPicking ? null : save,
                  icon: const Icon(Icons.check),
                  label: Text(l10n.btnSave),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PhotoField extends StatelessWidget {
  const _PhotoField({
    required this.photoPath,
    required this.onPick,
    required this.onRemove,
    required this.addLabel,
    required this.removeLabel,
  });

  final String? photoPath;
  final VoidCallback? onPick;
  final VoidCallback? onRemove;
  final String addLabel;
  final String removeLabel;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (photoPath != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(photoPath!),
              key: const ValueKey('photo-preview'),
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
        ),
      Wrap(
        spacing: 12,
        runSpacing: 8,
        children: [
          OutlinedButton.icon(
            key: const ValueKey('pick-photo'),
            onPressed: onPick,
            icon: const Icon(Icons.add_a_photo_outlined),
            label: Text(addLabel),
          ),
          if (photoPath != null) ...[
            TextButton.icon(
              key: const ValueKey('remove-photo'),
              onPressed: onRemove,
              icon: const Icon(Icons.delete_outline),
              label: Text(removeLabel),
            ),
          ],
        ],
      ),
    ],
  );
}
