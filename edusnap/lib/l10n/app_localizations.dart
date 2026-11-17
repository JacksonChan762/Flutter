import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'EduSnap'**
  String get appTitle;

  /// No description provided for @homeEmpty.
  ///
  /// In en, this message translates to:
  /// **'No moments yet. Tap + to add your first entry.'**
  String get homeEmpty;

  /// No description provided for @homeAddTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add entry'**
  String get homeAddTooltip;

  /// No description provided for @homeSettingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get homeSettingsTooltip;

  /// No description provided for @deleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete entry?'**
  String get deleteDialogTitle;

  /// No description provided for @deleteDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{title}\"? This cannot be undone.'**
  String deleteDialogBody(String title);

  /// No description provided for @btnCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get btnCancel;

  /// No description provided for @btnDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get btnDelete;

  /// No description provided for @btnOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get btnOk;

  /// No description provided for @btnSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get btnSave;

  /// No description provided for @btnFormat.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get btnFormat;

  /// No description provided for @btnClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get btnClear;

  /// No description provided for @addTitle.
  ///
  /// In en, this message translates to:
  /// **'Add entry'**
  String get addTitle;

  /// No description provided for @editTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit entry'**
  String get editTitle;

  /// No description provided for @fieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get fieldTitle;

  /// No description provided for @fieldTitleHint.
  ///
  /// In en, this message translates to:
  /// **'What did you learn?'**
  String get fieldTitleHint;

  /// No description provided for @fieldTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get fieldTitleRequired;

  /// No description provided for @fieldNote.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get fieldNote;

  /// No description provided for @titleMissingTitle.
  ///
  /// In en, this message translates to:
  /// **'Title missing'**
  String get titleMissingTitle;

  /// No description provided for @titleMissingBody.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title before saving.'**
  String get titleMissingBody;

  /// No description provided for @photoAdd.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get photoAdd;

  /// No description provided for @photoChange.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get photoChange;

  /// No description provided for @photoRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get photoRemove;

  /// No description provided for @photoCamera.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get photoCamera;

  /// No description provided for @photoGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get photoGallery;

  /// No description provided for @photoPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Permission needed'**
  String get photoPermissionTitle;

  /// No description provided for @photoPermissionBody.
  ///
  /// In en, this message translates to:
  /// **'EduSnap needs access to your {source} to add a photo.'**
  String photoPermissionBody(String source);

  /// No description provided for @photoSourceCamera.
  ///
  /// In en, this message translates to:
  /// **'camera'**
  String get photoSourceCamera;

  /// No description provided for @photoSourceGallery.
  ///
  /// In en, this message translates to:
  /// **'photo library'**
  String get photoSourceGallery;

  /// No description provided for @photoPermissionOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get photoPermissionOpenSettings;

  /// No description provided for @photoFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the {source}. Please try again.'**
  String photoFailed(String source);

  /// No description provided for @photoPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'No photo'**
  String get photoPlaceholder;

  /// No description provided for @detailTitle.
  ///
  /// In en, this message translates to:
  /// **'Detail'**
  String get detailTitle;

  /// No description provided for @detailEditTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit entry'**
  String get detailEditTooltip;

  /// No description provided for @detailNoNote.
  ///
  /// In en, this message translates to:
  /// **'No note added.'**
  String get detailNoNote;

  /// No description provided for @createdOn.
  ///
  /// In en, this message translates to:
  /// **'Created on {date}'**
  String createdOn(String date);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguageSection.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageSection;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageChinese.
  ///
  /// In en, this message translates to:
  /// **'繁體中文'**
  String get settingsLanguageChinese;

  /// No description provided for @settingsStorageSection.
  ///
  /// In en, this message translates to:
  /// **'Local storage'**
  String get settingsStorageSection;

  /// No description provided for @settingsStorageUsed.
  ///
  /// In en, this message translates to:
  /// **'{size} used'**
  String settingsStorageUsed(String size);

  /// No description provided for @settingsFormat.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get settingsFormat;

  /// No description provided for @settingsFormatHint.
  ///
  /// In en, this message translates to:
  /// **'Removes photos that no entry uses anymore.'**
  String get settingsFormatHint;

  /// No description provided for @settingsClear.
  ///
  /// In en, this message translates to:
  /// **'Clear all entries'**
  String get settingsClear;

  /// No description provided for @settingsClearHint.
  ///
  /// In en, this message translates to:
  /// **'Deletes every entry and its photo.'**
  String get settingsClearHint;

  /// No description provided for @settingsFormatConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Format storage?'**
  String get settingsFormatConfirmTitle;

  /// No description provided for @settingsFormatConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Unused photos will be deleted. Entries stay.'**
  String get settingsFormatConfirmBody;

  /// No description provided for @settingsFormatDone.
  ///
  /// In en, this message translates to:
  /// **'Unused photos removed.'**
  String get settingsFormatDone;

  /// No description provided for @settingsClearConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear all entries?'**
  String get settingsClearConfirmTitle;

  /// No description provided for @settingsClearConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Every entry and its photo will be deleted. This cannot be undone.'**
  String get settingsClearConfirmBody;

  /// No description provided for @settingsClearFinalTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get settingsClearFinalTitle;

  /// No description provided for @settingsClearFinalBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes all entries and photos.'**
  String get settingsClearFinalBody;

  /// No description provided for @settingsClearDone.
  ///
  /// In en, this message translates to:
  /// **'All entries cleared.'**
  String get settingsClearDone;

  /// No description provided for @settingsAboutSection.
  ///
  /// In en, this message translates to:
  /// **'About EduSnap'**
  String get settingsAboutSection;

  /// No description provided for @settingsAboutBody.
  ///
  /// In en, this message translates to:
  /// **'EduSnap is an offline photo journal. Entries and photos are stored on this device only.'**
  String get settingsAboutBody;

  /// No description provided for @settingsVersionTitle.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get settingsVersionTitle;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version} (build {build})'**
  String settingsVersion(String version, String build);

  /// No description provided for @settingsVersionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Version unavailable'**
  String get settingsVersionUnavailable;

  /// No description provided for @settingsVersionLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading version…'**
  String get settingsVersionLoading;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
