# Sessions 1–4 requirement audit

Reviewed on 17 November 2026 against the uploaded originals:

- `Itchi_Flutter_Session1.pptx` (23 slides)
- `Itchi_Flutter_Session2.pptx.pdf` (38 slides)
- `Itchi_Flutter_Session3.pptx` (36 slides)
- `Itchi_Flutter_Session4.pptx` (36 slides)

**Application implementation is complete against these slides. Native device
acceptance and workstation setup are still pending; this is not a claim that
every workshop checkpoint has been demonstrated on hardware.**

## Session 1 — Environment, MVC, initial demo

| Requirement | Evidence / status |
| --- | --- |
| Flutter project and `main()` entry | `edusnap/`, `lib/main.dart`; Flutter 3.47.9 / Dart 3.13.7 verified. |
| MVC folders | `Models/`, `Pages/`, `Component/`, `Utils/`; all four page/controller pairs exist. Models contain no UI or platform calls. |
| Reusable component with controller | `Component/JournalCard/journal_card.dart` and `journal_card_controller.dart`. |
| Personal development branch | `dev/jackson`; session commits `0fcdb18`, `c35d785`, `4d3c7c2`, `434575c`. |
| Cursor IDE/CLI and SourceTree | Workstation check pending; not claimed from the existence of remote editor directories. |
| `flutter doctor` has a native run target ready | Not complete in this container: Android SDK and Chrome are absent; the Linux target lacks GTK development libraries. iOS requires macOS/Xcode. Flutter/Dart are invoked with their full SDK paths. |
| Run on Simulator/Emulator | Pending on a native workstation. Widget tests and web compilation are separate checks. |
| Private repository setup | Historical setup instruction; Session 4's final submission explicitly requires public visibility. Current repository is verified public; it was not made private during this audit. |

## Session 2 — Lifecycle, four pages, navigation and edit challenge

| Slides | Requirement | Evidence / status |
| --- | --- | --- |
| 7–10 | Initialize outside `build`, clean up in `dispose`; save on background | Controllers load in `initState`; text controllers/listeners are disposed; background/inactive journal saves are tested. |
| 13–14 | Home is the List; exact page/controller folders | `Pages/HomePage`, `Detail`, `Add`, `Settings` use the workshop filenames. |
| 17 | Plain `JournalEntry` with title, note, createdAt | Data-only model; persistent random ID and optional photo path extend it. |
| 19, 36 | Three sample cards | First-ever load creates and persists exactly three samples. Clearing/deleting them remains empty after reopening. Existing saved journals are preserved. |
| 21–25 | Required title, optional note, return entry and insert at top | Trimmed validation/dialog; `Navigator.pop(entry)`; Home awaits the result. Widget and controller tests cover this. |
| 27, 34 | Card passes entry to Detail; Settings left, Add right | Home navigation and Detail display are covered by widget tests. |
| 29 | Swipe left to delete | Dismissible with delete background and confirmation; cancel and confirm paths tested. |
| 32–34 | Secondary pages can pop | Flutter Back works normally; native Duo Back replaces it only when available. Dialog-before-page popping is tested. |
| 37 | Reuse Add as Edit; prefill and update List/Detail | Identity/date preserved; system Back returns to the updated list. Cancelling a photo edit preserves the original photo and removes only drafts. |

## Session 3 — Permissions, photos, storage, language and clear challenge

| Slides | Requirement | Evidence / status |
| --- | --- | --- |
| 12 | Packages and iOS/Android declarations | `image_picker`, `permission_handler`; camera/photo usage strings, CAMERA, READ_MEDIA_IMAGES, legacy storage capped at API 32. SPM infers iOS permission flags from Info.plist. |
| 15 | Ask at use; camera/gallery; explain denial and open settings | Permission service and Add UI; Android API 32 versus 33/34 selection, limited access, native errors, denial dialog and settings action are tested. No request runs at launch. |
| 15 | Preview and persist the picked photo path | Add preview and copied file paths. Real temporary-file tests prove copies are independent and referenced files survive cleanup. |
| 17 | Image/placeholder on card and Detail | Card uses a photo placeholder; Detail now shows localized `No photo` when no path exists. |
| 20–22 | Save/load all fields across reopening | Real JSON repository tests reload entries with IDs, title, note, date and photo paths. Mutation saves are serialized; original photos are deleted after updated journal persistence. OS force-quit demonstration remains pending. |
| 24–28 | English and Traditional Chinese, saved selection | ARB files, generated delegates, Settings toggle; fresh repository loads and widget language changes are tested. |
| 30–31 | Localized created-date placeholder | `Created on {date}` / `{date} 建立` on card and Detail, with localized date formatting. |
| 34 | Storage size placeholder | `{size} used` / `已使用 {size}`, backed by actual photo-folder byte totals. |
| 34 | Format/Clear, double confirmation, delete journal/photos, 0 KB | Clear requires two confirmations, empties journal and removes photos. Tests check cancellation, committed clear and 0 KB. An additional Format action removes only unused files with one confirmation. |

## Session 4 — Icon, theme, version, Duo and own-logo challenge

| Slides | Requirement | Evidence / status |
| --- | --- | --- |
| 6–9 | Square opaque 1024×1024 PNG; generate iOS/Android icons | Original `assets/icon.png` is RGB, 1024×1024. Generated density assets and iOS catalog are committed; generator command is in README. Native launcher appearance needs reinstall verification. |
| 13 | Exact five demo colors in shared ThemeData | `Theme/app_theme.dart`; AppBar, buttons and cards use the theme. Widgets do not embed their own palette. |
| 20 | Read version/build and change pubspec version | `package_info_plus`, localized Settings display, pubspec `1.1.0+2`; tests verify changing metadata changes the displayed label. Web build metadata is checked; native rebuild/restart remains pending. |
| 26 | Install/import the workshop Git plugin | `itchi_flutter_duo_layout` Git dependency resolved in the lockfile. The project uses SPM and the plugin includes a Swift package. The slide's `pod install` is an alternative CocoaPods workflow, not an extra command to run without a Podfile. |
| 28 | Native side Back, hide Flutter Back when active | Root navigator observer follows pages, dialogs and sheets. Native availability/failure and disposal are tested with a fake bridge. |
| 28 | Fold stream; full-screen when fully open | `DuoLayoutController` subscribes to folds and lifts the content-width limit only for available fully-open snapshots. Closed/half-screen/error fallback tested. |
| 28 | Verify on iPhone Duo simulator | Pending on a supported Mac/Xcode and Duo simulator. Native Swift behavior is not verified by the mocked bridge. |
| 31 | Own logo, logo colors, own icon and theme | Original book/camera artwork uses the five documented palette colors; the app theme matches it. |
| 33 | Public GitHub repository, MVC, pages, functions | Repository public visibility verified. All source changes are published on the personal branch. The submission form is not submitted automatically. |

## Verification and remaining demonstration

See [the verification record](VERIFICATION.md) for automated checks and the
[root README](../../README.md) for commands. Earlier Session 1/2 documents
describe historical milestones; this audit describes the final persistent app.

On a native workstation, finish the checks the container cannot execute:

1. Verify Cursor IDE/CLI, SourceTree, and a clean native-target Flutter doctor.
2. Install the app and confirm the home-screen icon and three first-run cards.
3. Pick/take a real photo; exercise permission denial and opening settings.
4. Save a journal/photo, background and force-quit the app, reopen, then switch
   language and reopen again. Entries, photos and locale should survive.
5. Edit/remove a photo and cancel; confirm the saved photo survives. Save a
   replacement and confirm List/Detail update. Format and double-confirm Clear.
6. Change the version/build, rebuild/restart, and inspect Settings.
7. On Duo, check native Back and fully-open/closed layout on the simulator.

Only mark the device checks complete after observing them. A web build, passing
CI, or local test suite cannot replace those observations.
