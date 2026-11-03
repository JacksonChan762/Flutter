# Flutter — EduSnap

ITCHI Flutter workshop, **Session 1: environment, MVC, initial demo**.
The Flutter application lives in [`edusnap/`](edusnap/).

## Run

Install the Flutter stable SDK and add its `bin` directory to your PATH.
In the Coder workspace it is installed at `$HOME/.local/share/flutter`.

```sh
export PATH="$HOME/.local/share/flutter/bin:$PATH"
cd ~/edusnap
flutter pub get
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
# Or, on a machine with an Android/iOS target:
flutter devices
flutter run
```

Forward port 8080 through Coder to open the web demo.

## Session 1 scope

- EduSnap welcome/list screen, reusable journal card, demo/clear actions.
- `lib/Models/`: immutable data classes only.
- `lib/Component/JournalCard/`: reusable View + presentation Controller.
- `lib/Pages/JournalList/`: Page and Controller together; controller owns data.
- `lib/Utils/`: shared non-UI date formatting.
- Widget/controller tests and GitHub Actions checks.
- Personal development branch: `dev/jackson`; `main` is not modified.

The sample is **in memory only**. Add/detail/settings navigation, camera/gallery,
persistent offline storage, and language switching belong to Sessions 2–4 and
are deliberately not claimed as implemented in Session 1.

## Verify

```sh
cd edusnap
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build web
flutter doctor -v
```

## Environment limitations

This headless Linux Coder workspace does not demonstrate Cursor IDE or
SourceTree desktop installation, an Android emulator, or an iOS simulator.
Android SDK/device setup is required for Android runs; iOS requires macOS/Xcode.
Web build/tests are useful verification, not proof of an emulator run.
Repository privacy is not changed by this work; verify it in GitHub settings
before claiming the workshop's private-repository requirement is satisfied.

The repository was originally initialized in `/home/jackson`; the root
`.gitignore` intentionally excludes unrelated home-directory configuration,
SSH files, SDKs and caches. Do not run `git add -f` on those files.
