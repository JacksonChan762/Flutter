# EduSnap — ITCHI Flutter Sessions 1–4

Offline photo journal with Home, Add/Edit, Detail and Settings pages. Entries,
photos and language preferences persist on the device. The app follows the
workshop MVC folders and supports English and Traditional Chinese.

## Session 4

- Original EduSnap book-and-camera logo: [1024×1024 RGB PNG](assets/icon.png),
  with a solid green background and a separate adaptive foreground. Generated
  iOS, Android (including adaptive), and web icons are committed.
- The logo uses the workshop palette: primary `#025928`, secondary `#F25D27`,
  accent `#D9653B`, surface `#F2B29B`, background `#F2F2F2`. These colors live
  in `lib/Theme/app_theme.dart`; AppBars, buttons and cards use the shared theme.
  This also completes the custom-logo/theme challenge using the same palette.
- Settings reads version and build from `package_info_plus`, in both languages.
  This feature release changes `pubspec.yaml` to `1.1.0+2` (minor update).
- The workshop's Git dependency `itchi_flutter_duo_layout` provides native
  Back and fold events. Its resolved commit is recorded in `pubspec.lock`.
  A root navigator observer keeps Back aligned with pages, sheets and dialogs;
  Flutter's AppBar Back is hidden only after the rail reports availability.
  Fully open mode removes the 720-point content limit on every page; closed,
  half-screen and unavailable states restore the normal layout. Other platforms
  retain Flutter Back. Subscriptions and native controls are cleaned up.

## Run and regenerate

From this directory, with Flutter on your PATH:

```sh
flutter pub get
flutter run
# Regenerate the source artwork and all configured launcher icons:
dart run tool/generate_icon.dart
```

The icon script also preserves the boolean Swift asset setting that
`flutter_launcher_icons` 0.14.4 otherwise rewrites in newer Xcode projects.

Native iOS checks require a Mac with Xcode and the plugin's supported Duo
simulator/device and SDK. The project already declares the UIScene lifecycle.
The plugin documents Xcode/iOS 27.1+ for the fold stream and full inner screen.

## Acceptance checks

1. Reinstall on Android/iOS and inspect the new home-screen icon.
2. Visit every page and confirm the green AppBar, orange buttons and peach cards.
3. Open Settings and find `Version 1.1.0 (build 2)`. Change the version/build in
   `pubspec.yaml`, rebuild and restart, and check that the new values appear.
   On iOS, clean the Xcode build folder if it retains old version metadata.
4. On Duo, open Add, Detail/Edit and Settings. Check that only native Back is
   shown while the rail is available, and that it closes a dialog before a page.
   Returning home should remove native Back.
5. Fully open and close the device: content expands to the screen then returns
   to the readable width. On a normal phone or web, Flutter Back remains usable.

```sh
dart format --output=none --set-exit-if-changed lib test tool
flutter analyze
flutter test
flutter build web
```

See [verification](docs/VERIFICATION.md) for actual results and device limits,
and the [Session 2](docs/SESSION_2.md) and [Session 3](docs/SESSION_3.md) checklists
for the earlier sessions. [Root README](../README.md) has workspace run commands.

Source references: [workshop plugin](https://github.com/itchitechhk/itchi_flutter_duo_layout),
[version metadata](https://pub.dev/packages/package_info_plus),
[launcher generator](https://pub.dev/packages/flutter_launcher_icons).
