# Verification — Sessions 1–4 audit — 2026-11-17

All four uploaded presentations were read, including all 38 pages of the
Session 2 PDF. The [requirement audit](WORKSHOP_AUDIT.md) maps their tasks and
challenges to code and distinguishes implementation from device acceptance.

The audit added first-run samples without reseeding cleared journals,
restart-safe entry IDs, non-destructive photo editing with draft cleanup,
Android-version-specific gallery permissions, a Detail photo placeholder,
background journal saves, ordered persistence, and safe async notification
after page disposal. Existing saved entries retain their IDs and photos.

Additional tests use the real JSON repository with a mocked preferences backend
and actual temporary-file copies for the photo store. They exercise sample
initialization, cleared-state reopening, saved edits, legacy identities, unique
IDs, overlapping saves, language reload, file sizes/cleanup, cancelled photo
edits, draft ownership, copy failure, leaving during a picker wait, Android
32/33/34 permissions, limited access, permission exceptions, and denied UI.
These tests do not simulate an OS force-quit or native permission UI.

`flutter doctor -v` confirms Flutter 3.47.9 / Dart 3.13.7. This container still
lacks the Android SDK, Chrome and GTK development libraries. No iOS target is
available on Linux. Cursor IDE/CLI and SourceTree workstation setup is not
verified. Those facts prevent claiming every Session 1 environment checkpoint
or the native demonstrations is complete.

Public repository visibility and per-session development commits were verified.
The former private-repo instruction is superseded by Session 4's public final
submission. No submission form was sent.

Current automated results:

- `flutter analyze`: passed, no issues.
- `flutter build web`: passed, including the Wasm dry run.
- `flutter test`: all 49 passed (10 controller/utility, 13 general widget,
  18 audit integration/service cases, 8 Duo/version cases).
- Formatting: passed, no files need changes.
- Source icon: verified 1024×1024 RGB without alpha; iOS catalog references and
  all five Android launcher densities exist.
- Audit/README relative links: verified.

## Previous Session 4 verification — 2026-11-17

Environment: headless Linux Coder workspace. Flutter 3.47.9 stable, Dart 3.13.7.

- `flutter pub get`: passed, including the workshop Git plugin (resolved commit
  `821121bfc3ebe540f344880904cf41ef355b5e66`).
- `dart run tool/generate_icon.dart`: passed; regenerated Android, iOS and web
  icons and preserved the Xcode Swift asset generation settings.
- Source PNG verified as 1024×1024 RGB (no alpha); all iOS catalog images exist.
- `dart format --output=none --set-exit-if-changed lib test tool`: passed.
- `flutter analyze`: passed, no issues.
- `flutter test`: all 30 tests passed (10 controller/utility, 12 general widget,
  8 Session 4 cases).
- `flutter build web`: passed, including the Wasm dry run.

New tests exercise version/build metadata changes, native Back with a dialog
above a page, hiding Back at home, subscription cleanup, unavailable/error rail
fallback, retrying a native view after attachment, and expanding/restoring
content width for fully-open, closed and half-screen folds.

The follow-up checks reproduced two missed regressions before fixing them:
Format deleted a photo still used by an entry, and Settings overflowed on a
320×640 phone. Format now obtains the current referenced paths from Home;
storage and photo-edit buttons wrap onto another line when needed. Both cases
are covered by the passing widget suite.

The first Session 4 GitHub Actions run failed during analysis because the
moving stable SDK reported Material imports as deprecated. The workflow now
pins Flutter 3.47.9 to match this verified environment. See the live Actions
page for remote results; the local results above do not imply remote CI passed.

Not performed in this Linux environment: iOS/Android builds or device runs,
CocoaPods installation, home-screen/reinstall checks, real Duo native rail and
fold behavior, or real version-change/restart checks. This iOS project uses
Swift Package Manager and the Duo plugin ships a Swift package; no Podfile is
present. On a supported Mac, run `flutter pub get` then
`flutter run -d "iPhone Duo"` and follow the README acceptance checks.
Use CocoaPods installation only if the project is configured to use CocoaPods.
Mocked plugin tests do not verify the upstream Swift code or simulator support.
Remote GitHub Actions results are separate from these local checks.

## Historical verification — Session 3 — 2026-11-11

Environment: headless Linux Coder workspace `Flutter`.
SDK: Flutter 3.47.9 stable; Dart 3.13.7.

- `dart format --output=none --set-exit-if-changed lib test`: passed.
- `flutter analyze`: passed, no issues.
- `flutter test`: all 20 tests passed (10 controller/utility, 10 widget).
- `flutter build web`: passed (see below).

Session 3 tests cover: loading saved entries, persistence on add/update/remove,
photo file deletion on replace/remove, clear-all, journal JSON round trip,
storage size formatting, language switch + saved choice, localized date
placeholder, storage size + double-confirmation clear, empty state, delete
confirmation and narrow 320×640 layout.

Not performed: interactive browser run, physical-device or emulator run,
real camera/gallery permission prompts. Web build and widget tests do not
substitute for those checks. Data now persists via shared_preferences; photos
are copied into the app documents directory.
GitHub Actions is configured but remote CI status is not asserted here.
