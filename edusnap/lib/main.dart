import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Pages/HomePage/HomePage.dart';
import 'Component/DuoLayout/duo_layout.dart';
import 'Services/duo_platform.dart';
import 'Services/settings_repository.dart';
import 'Theme/app_theme.dart';
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
    this.duoPlatform,
  });

  /// Null means follow the device locale.
  final String? initialLanguageCode;
  final SettingsRepository? settingsRepository;
  final DuoPlatform? duoPlatform;

  /// Overrides the home page; tests inject fake storage here.
  final Widget Function(ValueChanged<String> onLanguageChanged)? home;

  @override
  State<EduSnapApp> createState() => _EduSnapAppState();
}

class _EduSnapAppState extends State<EduSnapApp> {
  late final DuoLayoutController _duo = DuoLayoutController(
    platform: widget.duoPlatform,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _duo.start();
    });
  }

  @override
  void dispose() {
    _duo.dispose();
    super.dispose();
  }

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
    theme: AppTheme.light,
    navigatorKey: _duo.navigatorKey,
    navigatorObservers: [_duo.observer],
    builder: (context, child) => DuoLayoutScope(
      controller: _duo,
      child: child ?? const SizedBox.shrink(),
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
