# Flutter — EduSnap

ITCHI Flutter workshop, Sessions 1–2. Application: [`edusnap/`](edusnap/).
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

- HomePage is the List: three sample entries, reusable journal cards.
- Top-left Settings; top-right Add; tapping a card opens Detail.
- Add uses a required title and optional note; blank/whitespace title shows a dialog.
- Saving returns a JournalEntry to Home, which inserts it at the top.
- Swipe left, confirm deletion; cancelling keeps the entry.
- Challenge: Detail → Edit reuses AddPage with prefilled fields. Save updates
  both Detail and List; cancel leaves the original unchanged. Creation time
  and identity are preserved, including after multiple edits.
- MVC folders match the workshop: `Models/JournalEntry.dart`,
  `Pages/HomePage/`, `Pages/Detail/`, `Pages/Add/`, `Pages/Settings/`,
  `Component/JournalCard/`. PascalCase workshop files explicitly opt out of
  Dart's filename lint; other recommended lint rules remain enabled.
- Controllers are initialized once in `initState`, disposed with their page;
  build methods render state without loading data or side effects.

**Memory only:** restarting resets the journal to the three samples.
No camera, gallery, persistence or language switching is claimed.
Settings explains these limits rather than showing nonfunctional toggles.

## Verify

```sh
cd edusnap
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build web
```

See [Session 2 checklist](edusnap/docs/SESSION_2.md) and
[verification](edusnap/docs/VERIFICATION.md). GitHub Actions runs the same checks.
Local test success does not assert that remote CI has passed.

## Environment limitations

This headless Linux Coder workspace has not verified Android/iOS device or
emulator runs. Android needs an SDK/device; iOS needs macOS/Xcode. Desktop IDE
setup and repository privacy are not verified or changed.

The repository root is `/home/jackson`. Its `.gitignore` excludes unrelated
home configuration, SSH files, SDKs and caches; never force-add those files.
