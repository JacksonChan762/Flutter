# Session 3 checklist — Permissions, photo, local storage, language

Workshop deck: `Itchi_Flutter_Session3.pdf` (Device, storage, language).

## Part 1 — Permissions

- [x] `image_picker` and `permission_handler` added to `pubspec.yaml`.
- [x] iOS `ios/Runner/Info.plist`: `NSCameraUsageDescription`,
      `NSPhotoLibraryUsageDescription`, `CFBundleLocalizations` (en, zh).
- [x] Android `AndroidManifest.xml`: `CAMERA`, `READ_MEDIA_IMAGES`,
      `READ_EXTERNAL_STORAGE` (maxSdkVersion 32), optional camera feature.
- [x] `flutter pub get` clean.
- Permission is requested at the moment of use (camera or gallery button),
  not on first launch.

## Part 2 — Camera and gallery

- [x] Add page: “Add photo” → bottom sheet (Take photo / Choose from gallery).
- [x] Permission granted → picker opens; the picked image is copied into the
      app documents folder (`entry_photos/`) by `PhotoStore`.
- [x] Permission denied → dialog explains why, with an “Open settings” button.
- [x] The photo path is stored on `JournalEntry.photoPath`.
- [x] Journal card shows a thumbnail (or a placeholder); Detail shows the photo.
- [x] Photo can be replaced or removed; the old file is deleted.

## Part 3 — Local storage

- [x] `shared_preferences` stores the journal as one JSON string
      (`journal_entries_v1`); `path_provider` locates the photo folder.
- [x] `HomePageController.load()` runs in `initState`.
- [x] Add / edit / delete / clear save immediately.
- [x] Fields saved: id, title, note, createdAt (ISO-8601), photoPath.
- [x] Malformed rows are skipped instead of crashing the list.
- [ ] Manual check on a device: add an entry → force quit → reopen.

## Part 4 — Language

- [x] `flutter_localizations` + `intl`, `generate: true`, `l10n.yaml`.
- [x] ARB files `lib/l10n/app_en.arb` and `lib/l10n/app_zh.arb`
      (Traditional Chinese), keys named `page_item` / `btn_*`.
- [x] `MaterialApp` uses `AppLocalizations.delegate` and
      `supportedLocales`; `zh` resolves to Traditional Chinese.
- [x] Settings has an English / 繁體中文 toggle; the choice is saved in
      shared preferences and applied on the next launch.
- [x] Placeholder used for the created date: `Created on {date}` /
      `{date} 建立`, shown on Detail and the card. Dates are formatted with
      `DateFormat.yMMMd(locale)` so the Chinese date reads 2026年1月2日.

## Challenge (Session 3)

- [x] Settings shows local storage size with a placeholder:
      `{size} used` / `已使用 {size}` (e.g. `0 KB used` / `已使用 0 KB`).
- [x] Format button (single confirm) removes photos no entry references.
- [x] Clear button with **two** confirmations deletes every entry and photo.
- [x] After clearing, the size reads 0 KB.

## Not verified here

This headless Coder workspace has no Android/iOS device, emulator or camera,
so the real permission prompts and picker flow are **not** executed. Widget
tests use fake pickers/storage; `flutter build web` only proves the web target
compiles (image_picker on web uses file input, permission_handler is a no-op).
