# Session 1 acceptance checklist

## Implemented

- Flutter project named `edusnap`, with Android, iOS and web scaffolding.
- Entry point and an interactive welcome journal list.
- Exact workshop folder names: `Models`, `Component`, `Pages`, `Utils`.
- Models contain data only. Views display values and delegate actions.
- Page controller owns demo entries and notifies the UI with ChangeNotifier.
- Reusable card has its own view and presentation controller.
- Tests cover controller notifications, immutable list exposure, date formatting,
  clear/reload UI behaviour, and a narrow phone viewport.
- Personal development branch `dev/jackson`.

## Requires a local workstation / account check

- Cursor IDE and CLI installation, SourceTree installation.
- Android SDK, emulator or attached device; iOS simulator requires macOS/Xcode.
- Run `flutter run` on one of those devices and show the welcome screen.
- Confirm the existing GitHub repository is private in repository settings.

## Deferred by the supplied course outline

Session 2: four screens, navigation and forms.
Session 3: permissions, camera/gallery, local storage and i18n.
Session 4: lifecycle, polish and the full offline demonstration.

The starter intentionally does not imply that in-memory demo data survives
restarting the app, or that camera / language features already exist.
