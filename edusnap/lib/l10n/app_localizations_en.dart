// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'EduSnap';

  @override
  String get homeEmpty => 'No moments yet. Tap + to add your first entry.';

  @override
  String get homeAddTooltip => 'Add entry';

  @override
  String get homeSettingsTooltip => 'Settings';

  @override
  String get deleteDialogTitle => 'Delete entry?';

  @override
  String deleteDialogBody(String title) {
    return 'Delete \"$title\"? This cannot be undone.';
  }

  @override
  String get btnCancel => 'Cancel';

  @override
  String get btnDelete => 'Delete';

  @override
  String get btnOk => 'OK';

  @override
  String get btnSave => 'Save';

  @override
  String get btnFormat => 'Format';

  @override
  String get btnClear => 'Clear';

  @override
  String get addTitle => 'Add entry';

  @override
  String get editTitle => 'Edit entry';

  @override
  String get fieldTitle => 'Title';

  @override
  String get fieldTitleHint => 'What did you learn?';

  @override
  String get fieldTitleRequired => 'Title is required';

  @override
  String get fieldNote => 'Note (optional)';

  @override
  String get titleMissingTitle => 'Title missing';

  @override
  String get titleMissingBody => 'Please enter a title before saving.';

  @override
  String get photoAdd => 'Add photo';

  @override
  String get photoChange => 'Change photo';

  @override
  String get photoRemove => 'Remove photo';

  @override
  String get photoCamera => 'Take photo';

  @override
  String get photoGallery => 'Choose from gallery';

  @override
  String get photoPermissionTitle => 'Permission needed';

  @override
  String photoPermissionBody(String source) {
    return 'EduSnap needs access to your $source to add a photo.';
  }

  @override
  String get photoSourceCamera => 'camera';

  @override
  String get photoSourceGallery => 'photo library';

  @override
  String get photoPermissionOpenSettings => 'Open settings';

  @override
  String photoFailed(String source) {
    return 'Could not open the $source. Please try again.';
  }

  @override
  String get photoPlaceholder => 'No photo';

  @override
  String get detailTitle => 'Detail';

  @override
  String get detailEditTooltip => 'Edit entry';

  @override
  String get detailNoNote => 'No note added.';

  @override
  String createdOn(String date) {
    return 'Created on $date';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguageSection => 'Language';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageChinese => '繁體中文';

  @override
  String get settingsStorageSection => 'Local storage';

  @override
  String settingsStorageUsed(String size) {
    return '$size used';
  }

  @override
  String get settingsFormat => 'Format';

  @override
  String get settingsFormatHint => 'Removes photos that no entry uses anymore.';

  @override
  String get settingsClear => 'Clear all entries';

  @override
  String get settingsClearHint => 'Deletes every entry and its photo.';

  @override
  String get settingsFormatConfirmTitle => 'Format storage?';

  @override
  String get settingsFormatConfirmBody =>
      'Unused photos will be deleted. Entries stay.';

  @override
  String get settingsFormatDone => 'Unused photos removed.';

  @override
  String get settingsClearConfirmTitle => 'Clear all entries?';

  @override
  String get settingsClearConfirmBody =>
      'Every entry and its photo will be deleted. This cannot be undone.';

  @override
  String get settingsClearFinalTitle => 'Are you sure?';

  @override
  String get settingsClearFinalBody =>
      'This permanently deletes all entries and photos.';

  @override
  String get settingsClearDone => 'All entries cleared.';

  @override
  String get settingsAboutSection => 'About EduSnap';

  @override
  String get settingsAboutBody =>
      'EduSnap is an offline photo journal. Entries and photos are stored on this device only.';
}
