import 'package:shared_preferences/shared_preferences.dart';

/// Stores the small app-wide preferences (language).
class SettingsRepository {
  static const languageKey = 'app_language';

  Future<String?> loadLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(languageKey);
  }

  Future<void> saveLanguageCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(languageKey, code);
  }
}
