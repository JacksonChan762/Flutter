# Session 1 acceptance checklist

Historical milestone: commit `0fcdb18`. The current app and all four uploaded
decks are reviewed in [the final audit](WORKSHOP_AUDIT.md). Session 4 supersedes
the private-repository setup step with a public-submission requirement.

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
- Historical setup requested a private repository. The final submission now
  requires public visibility; the repository is verified public.

## Deferred by the supplied course outline

Session 2: four screens, navigation and forms.
Session 3: permissions, camera/gallery, local storage and i18n.
Session 4: lifecycle, polish and the full offline demonstration.

The starter intentionally does not imply that in-memory demo data survives
restarting the app, or that camera / language features already exist.
