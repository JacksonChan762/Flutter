import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Pages/HomePage/HomePage.dart';
import 'Services/settings_repository.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedLanguage = await SettingsRepository().loadLanguageCode();
  runApp(EduSnapApp(initialLanguageCode: savedLanguage));
}

class EduSnapApp extends StatefulWidget {
  const EduSnapApp({
    super.key,
    this.initialLanguageCode,
    this.settingsRepository,
    this.home,
  });

  /// Null means follow the device locale.
  final String? initialLanguageCode;
  final SettingsRepository? settingsRepository;

  /// Overrides the home page; tests inject fake storage here.
  final Widget Function(ValueChanged<String> onLanguageChanged)? home;

  @override
  State<EduSnapApp> createState() => _EduSnapAppState();
}

class _EduSnapAppState extends State<EduSnapApp> {
  late final SettingsRepository _settings =
      widget.settingsRepository ?? SettingsRepository();
  late Locale? _locale = widget.initialLanguageCode == null
      ? null
      : Locale(widget.initialLanguageCode!);

  /// Called by the Settings page; the choice is saved and applied app-wide.
  Future<void> changeLanguage(String languageCode) async {
    await _settings.saveLanguageCode(languageCode);
    if (!mounted) return;
    setState(() => _locale = Locale(languageCode));
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF146C60)),
      useMaterial3: true,
    ),
    locale: _locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home:
        widget.home?.call(changeLanguage) ??
        HomePage(onLanguageChanged: changeLanguage),
  );
}
