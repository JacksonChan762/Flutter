# Session 2 — Lifecycle, UI, navigation

Historical milestone: commit `c35d785`. The uploaded PDF has now been read in
full; see [the final audit](WORKSHOP_AUDIT.md) for current acceptance status.
Session 3 added persistence. The final app seeds three cards only on first
launch, preserves later edits/deletions, and does not restore cleared samples.
It also saves when backgrounded; the memory-only walkthrough below records the
earlier Session 2 behavior.

Based on Itchi_Flutter_Session2.pdf, including the final Challenge.

## Acceptance checklist

- HomePage is the List (no separate List page). Main opens HomePage.
- Page/controller pairs under Pages/HomePage, Detail, Add, Settings with the
  exact workshop filenames, e.g. DetailPage.dart and DetailPageController.dart.
- JournalEntry is data only with required title, note, createdAt; an extra
  stable id identifies entries independently of duplicate titles and edits.
- Home controller holds the list; initializes three samples once per page.
- JournalCard displays title, note and date inside a tappable Card.
- Top-left Settings opens Settings; top-right Add awaits Navigator.push result.
- Add validates trimmed title and shows a missing-title dialog; note optional.
- Save uses Navigator.pop(entry); Home inserts result at the top.
- Tap card passes that entry to Detail. All secondary pages have Back.
- Swipe end-to-start shows delete background; confirm removes, cancel retains.
- Challenge: Detail Edit pushes AddPage(existing entry); fields prefill.
  Save returns a new immutable entry preserving id and createdAt. Detail
  updates immediately and notifies Home, so system-back also preserves edits.
- Controllers and text fields are cleaned up in dispose; loading occurs in
  initState, not build. No app-background persistence is implemented yet.

## Manual walkthrough

1. Start: three cards. Open any card; title/note/date match. Back returns List.
2. Settings: storage limitations visible; Back returns List.
3. Add: empty or whitespace title → dialog. Dismiss, enter title, leave note
   blank, Save → new first card. Open it → no-note message.
4. Detail → Edit: fields prefilled. Change title/note, Save → updated Detail.
   System Back → same updated card, without a duplicate.
5. Start Add/Edit, change fields then Back → no saved change.
6. Swipe left: Cancel keeps card; Delete removes it. Delete all → empty state.
7. Restart: three sample cards return (Session 2 is intentionally memory-only).

## Automated coverage

Ten tests cover controller mutations and notifications, read-only list,
identity/date preservation, trimmed validation, optional notes, three samples,
all page routes, add placement, edit synchronization through system Back,
cancel behavior, delete confirm/cancel and empty state, narrow-phone layout.
Widget tests are not a device/emulator or interactive browser test.
