// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'EduSnap';

  @override
  String get homeEmpty => '還沒有記錄。按 + 新增第一篇。';

  @override
  String get homeAddTooltip => '新增記錄';

  @override
  String get homeSettingsTooltip => '設定';

  @override
  String get deleteDialogTitle => '刪除記錄？';

  @override
  String deleteDialogBody(String title) {
    return '刪除「$title」？此操作無法復原。';
  }

  @override
  String get btnCancel => '取消';

  @override
  String get btnDelete => '刪除';

  @override
  String get btnOk => '確定';

  @override
  String get btnSave => '儲存';

  @override
  String get btnFormat => '整理';

  @override
  String get btnClear => '清除';

  @override
  String get addTitle => '新增記錄';

  @override
  String get editTitle => '編輯記錄';

  @override
  String get fieldTitle => '標題';

  @override
  String get fieldTitleHint => '今天學到什麼？';

  @override
  String get fieldTitleRequired => '請輸入標題';

  @override
  String get fieldNote => '備註（選填）';

  @override
  String get titleMissingTitle => '尚未填寫標題';

  @override
  String get titleMissingBody => '儲存前請先輸入標題。';

  @override
  String get photoAdd => '加相片';

  @override
  String get photoChange => '換相片';

  @override
  String get photoRemove => '移除相片';

  @override
  String get photoCamera => '拍照';

  @override
  String get photoGallery => '從相冊選擇';

  @override
  String get photoPermissionTitle => '需要權限';

  @override
  String photoPermissionBody(String source) {
    return 'EduSnap 需要取用$source才能加相片。';
  }

  @override
  String get photoSourceCamera => '相機';

  @override
  String get photoSourceGallery => '相冊';

  @override
  String get photoPermissionOpenSettings => '開啟設定';

  @override
  String photoFailed(String source) {
    return '無法開啟$source，請再試一次。';
  }

  @override
  String get photoPlaceholder => '尚未加相片';

  @override
  String get detailTitle => '詳情';

  @override
  String get detailEditTooltip => '編輯記錄';

  @override
  String get detailNoNote => '尚未加備註。';

  @override
  String createdOn(String date) {
    return '$date 建立';
  }

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsLanguageSection => '語言';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageChinese => '繁體中文';

  @override
  String get settingsStorageSection => '本機儲存';

  @override
  String settingsStorageUsed(String size) {
    return '已使用 $size';
  }

  @override
  String get settingsFormat => '整理';

  @override
  String get settingsFormatHint => '清除已沒有記錄使用的相片。';

  @override
  String get settingsClear => '清除所有記錄';

  @override
  String get settingsClearHint => '刪除所有記錄及其相片。';

  @override
  String get settingsFormatConfirmTitle => '整理儲存？';

  @override
  String get settingsFormatConfirmBody => '將刪除不再使用的相片，記錄保留。';

  @override
  String get settingsFormatDone => '已清除多餘相片。';

  @override
  String get settingsClearConfirmTitle => '清除所有記錄？';

  @override
  String get settingsClearConfirmBody => '所有記錄及其相片將被刪除，無法復原。';

  @override
  String get settingsClearFinalTitle => '確定要清除？';

  @override
  String get settingsClearFinalBody => '此操作會永久刪除所有記錄和相片。';

  @override
  String get settingsClearDone => '已清除所有記錄。';

  @override
  String get settingsAboutSection => '關於 EduSnap';

  @override
  String get settingsAboutBody => 'EduSnap 是離線相片日記。記錄和相片只儲存在本機。';

  @override
  String get settingsVersionTitle => '應用程式版本';

  @override
  String settingsVersion(String version, String build) {
    return '版本 $version（組建 $build）';
  }

  @override
  String get settingsVersionUnavailable => '無法取得版本';

  @override
  String get settingsVersionLoading => '正在讀取版本…';
}
