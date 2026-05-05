import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:soulpet/core/di/injection.dart';
import 'package:soulpet/core/l10n/locale_provider.dart';
import 'package:soulpet/core/profile/user_profile_provider.dart';
import 'package:soulpet/core/router/app_router.dart';
import 'package:soulpet/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  await configureDependencies();
  await LiquidGlassWidgets.initialize();
  // Pre-warm the user-profile cache so that gendered copy is correct on the
  // very first frame after the splash.
  await UserProfileProvider.instance.load();

  runApp(const SoulPetApp());
}

class SoulPetApp extends StatefulWidget {
  const SoulPetApp({super.key});

  @override
  State<SoulPetApp> createState() => _SoulPetAppState();
}

class _SoulPetAppState extends State<SoulPetApp> {
  @override
  void initState() {
    super.initState();
    LocaleProvider.instance.addListener(_onLocaleChanged);
  }

  void _onLocaleChanged() => setState(() {});

  @override
  void dispose() {
    LocaleProvider.instance.removeListener(_onLocaleChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = LocaleProvider.instance.locale.languageCode;
    return MaterialApp.router(
      key: ValueKey(lang),
      title: 'SoulPet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      locale: LocaleProvider.instance.locale,
      supportedLocales: const [Locale('en'), Locale('ru')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: AppRouter.router,
    );
  }
}
