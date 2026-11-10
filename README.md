# Flutter — EduSnap

ITCHI Flutter workshop, Sessions 1–3. Application: [`edusnap/`](edusnap/).
Development branch: `dev/jackson`; `main` is not modified.

## Run

```sh
export PATH="$HOME/.local/share/flutter/bin:$PATH"
cd ~/edusnap
flutter pub get
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
# Or on a machine with an Android/iOS target:
flutter devices
flutter run
```

Forward port 8080 through Coder to open the web demo.

## Session 2

- HomePage is the List; top-left Settings, top-right Add; tapping a card opens
  Detail. Add requires a title; swipe left to delete with confirmation.
- Detail → Edit reuses AddPage with prefilled fields; identity and creation
  time are preserved.
- MVC folders match the workshop: `Models/`, `Pages/HomePage|Detail|Add|Settings/`,
  `Component/JournalCard/`, plus `Services/` and `Utils/`.

## Session 3

- **Permissions:** `image_picker` + `permission_handler`; camera and photo
  library usage strings in `ios/Runner/Info.plist`, `CAMERA` /
  `READ_MEDIA_IMAGES` in `AndroidManifest.xml`. Asked at the moment of use;
  denial shows a dialog with an “Open settings” button.
- **Photo:** Add page picks from camera or gallery, shows a preview, stores the
  path on `JournalEntry.photoPath`; photos are copied into the app documents
  folder (`entry_photos/`) so they survive restarts. Cards show a thumbnail,
  Detail shows the photo.
- **Local storage:** `shared_preferences` holds the journal as JSON; loaded in
  `HomePage.initState`, saved after add / edit / delete / clear.
- **Language:** `flutter_localizations` + `intl` with ARB files in `lib/l10n`
  (English + Traditional Chinese). Settings toggles the language, the choice is
  saved and restored on launch. Created dates use the `Created on {date}` /
  `{date} 建立` placeholder.
- **Challenge:** Settings shows the photo storage size (`{size} used` /
  `已使用 {size}`), a Format button (removes unused photos) and a Clear button
  with double confirmation that deletes all entries and photos (size → 0 KB).

See [Session 3 checklist](edusnap/docs/SESSION_3.md).

## Verify

```sh
cd edusnap
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build web
```

See [Session 2](edusnap/docs/SESSION_2.md) and
[Session 3](edusnap/docs/SESSION_3.md) checklists and
[verification](edusnap/docs/VERIFICATION.md). GitHub Actions runs the same checks.
Local test success does not assert that remote CI has passed.

## Environment limitations

This headless Linux Coder workspace has not verified Android/iOS device or
emulator runs. Android needs an SDK/device; iOS needs macOS/Xcode. Desktop IDE
setup and repository privacy are not verified or changed.

The repository root is `/home/jackson`. Its `.gitignore` excludes unrelated
home configuration, SSH files, SDKs and caches; never force-add those files.
