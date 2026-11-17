# EduSnap

<img src="edusnap/assets/icon.png" alt="EduSnap book and camera icon" width="96">

An offline photo journal built for the ITCHI Flutter workshop, Sessions 1–4.
Create a learning moment, attach a photo, revisit it, and switch between English
and Traditional Chinese. The Flutter application is in [`edusnap/`](edusnap/).

## Features

| Area | What the app does |
| --- | --- |
| Journal | Add an entry with a required title and optional note/photo; open Detail, edit, or swipe left to delete with confirmation. |
| Photos | Pick from the camera or gallery, preview and remove photos, and copy them into the app documents directory for persistence. |
| Storage | Save entries locally as JSON through `shared_preferences`; remove unused photos with Format; clear all entries/photos with two confirmations. |
| Language | Translate the interface and dates into English or Traditional Chinese; restore the language choice on launch. |
| Branding | Use an original 1024×1024 book-and-camera icon for iOS, Android/adaptive icons and web, with a matching application theme. |
| Version | Read the installed version and build number with `package_info_plus` and show both in Settings. Current release: `1.1.0+2`. |
| Duo layout | Use the workshop's native iOS plugin for side-rail Back and fold events; expand content when fully open and retain Flutter Back whenever the rail is unavailable. |

Data stays on the device; this app has no account or backend. Photo storage uses
native filesystem APIs. Web compilation is checked, but browser photo storage
and camera/gallery flows have not been verified; use a native target for them.

## Requirements and setup

The tested SDK is **Flutter 3.47.9 stable / Dart 3.13.7**. GitHub Actions pins
that Flutter version so its analyzer and formatter match the local checks.
Use Git and an Android SDK/device or a Mac with Xcode for native runs.

```sh
git clone --branch dev/jackson https://github.com/JacksonChan762/Flutter.git
cd Flutter/edusnap
flutter pub get
flutter devices
flutter run
```

In the existing Coder workspace, the app is `/home/jackson/edusnap` and the SDK
is `/home/jackson/.local/share/flutter/bin`. Add that SDK directory to your PATH
if `flutter` is not already available.

For a browser preview of the interface:

```sh
cd edusnap # from the repository root
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
```

Forward port 8080 in Coder. This preview does not validate native photo storage,
permissions, or Duo hardware behavior.

## App structure

The workshop MVC organization separates pages/controllers, models and services:

```text
edusnap/
  lib/
    Models/JournalEntry.dart
    Pages/
      HomePage/   # list, navigation and journal persistence
      Add/        # shared add/edit form and photo selection
      Detail/     # entry display and editing
      Settings/   # language, storage and version
    Component/
      JournalCard/
      DuoLayout/  # navigator observation, fold state and rail lifecycle
    Services/     # journal/settings repositories, photo store/picker, Duo bridge
    Theme/        # shared application colors and component themes
    Utils/        # localized date formatting
    l10n/         # English and Traditional Chinese ARB resources
  assets/         # source icon and adaptive foreground
  test/           # controller, widget and Duo regression tests
  tool/           # reproducible icon generator
```

## Session 4: icon, theme, version and plugin

The original logo and shared theme use the workshop palette:

| Role | Color |
| --- | --- |
| Primary | `#025928` |
| Secondary | `#F25D27` |
| Accent | `#D9653B` |
| Surface | `#F2B29B` |
| Background | `#F2F2F2` |

[`AppTheme`](edusnap/lib/Theme/app_theme.dart) applies these colors to AppBars,
buttons and cards. Regenerate the source artwork and platform icons from the app
directory with:

```sh
dart run tool/generate_icon.dart
```

The source icon is a solid-background 1024×1024 RGB PNG. The script uses
`flutter_launcher_icons` and preserves a Swift asset build setting that version
0.14.4 otherwise rewrites in newer Xcode projects.

To change the displayed version, edit `version: 1.1.0+2` in
[`pubspec.yaml`](edusnap/pubspec.yaml), rebuild and restart. `1.1.0` is the
version; `2` is the build number. On iOS, clean the Xcode build folder if old
metadata is retained. The displayed text comes from the package metadata rather
than a hardcoded label.

The [Duo plugin](https://github.com/itchitechhk/itchi_flutter_duo_layout) is a Git
dependency, with its resolved commit recorded in `pubspec.lock`. This iOS
project uses Swift Package Manager and the plugin includes a Swift package.
On a supported Mac, run `flutter pub get`, then `flutter run -d "iPhone Duo"`.
Follow the plugin's SDK requirements for native fold and rail support. Use
`pod install` only if you configure the app to use CocoaPods; this project has
no Podfile.

The root navigator handles native Back for pages, sheets and dialogs. Flutter
AppBar Back is hidden only when the native rail reports availability. Fully
open mode removes the normal 720-point content limit; closing or entering
half-screen mode restores it. Non-iOS platforms keep Flutter navigation.

## Test and verify

Run these commands from `edusnap/`:

```sh
flutter pub get
dart format --output=none --set-exit-if-changed lib test tool
flutter analyze
flutter test
flutter build web
```

Local verification on **17 November 2026** with the SDK above:

| Check | Result |
| --- | --- |
| Formatting | Passed |
| Static analysis | Passed, no issues |
| Automated tests | All 30 passed |
| Release web build | Passed, including the Wasm dry run |

The tests cover journal CRUD, persistence callbacks, photo cleanup, editing,
localization, confirmation dialogs, version metadata, native Back/fallback,
fold layout and narrow phone layouts. Storage cleanup is specifically tested
to preserve photos that are still referenced by entries.

See the [verification record](edusnap/docs/VERIFICATION.md) for the latest
results. [GitHub Actions](https://github.com/JacksonChan762/Flutter/actions)
runs the same checks with the pinned SDK. A successful web build or mocked
plugin test does not verify native permissions, home-screen icons or Duo Swift
code on a real device.

Manual acceptance checks still require a native device/simulator:

1. Add, edit, reopen and delete entries, including one with a real photo.
2. Restart and confirm entries/photos and the language preference survive.
3. Format storage and confirm used photos remain; cancel and confirm Clear.
4. Reinstall and inspect the launcher icon; check the theme on every page.
5. Change the version/build, rebuild and confirm Settings shows the new values.
6. On Duo, verify rail Back closes dialogs before pages and disappears at home;
   fully open/close the device to check the content width change.

## Workshop notes

- [Session 1](edusnap/docs/SESSION_1.md)
- [Session 2](edusnap/docs/SESSION_2.md)
- [Session 3](edusnap/docs/SESSION_3.md)
- [Session 4 implementation and acceptance checks](edusnap/README.md)

The repository root in this workspace is the home directory. Its `.gitignore`
allows only project files; keep personal configuration, credentials, SDKs and
caches out of Git.
