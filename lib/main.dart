import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter/services.dart';
import 'package:o_health/screens/auth/login.dart';
import 'package:o_health/screens/auth/register.dart';
import 'package:o_health/screens/auth/forget_password.dart';
import 'package:o_health/screens/auth/reset_password.dart';
import 'package:o_health/screens/description.dart';
import 'package:o_health/screens/home.dart';
import 'package:o_health/screens/intros/initial_intro.dart';
import 'package:o_health/screens/intros/login_intro.dart';
import 'package:o_health/screens/upload_files.dart';
import 'package:o_health/services/ask_permission.dart';
import 'package:o_health/services/certificate.dart';
import 'package:o_health/theme_config/theme_config.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

void main() async {
  var widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await EasyLocalization.ensureInitialized();
  //for certificate verification
  HttpOverrides.global = CreateHttpOverrides();
  //add license file
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  //ask permissions
  await HandlePermissions.askPermission();
  try {
    await FlutterDisplayMode.setHighRefreshRate();
  } catch (_) {}
  // Initialize hive db;
  Hive.init((await getApplicationDocumentsDirectory()).path);
  //Create hive box
  Box hive = await Hive.openBox('data');
  hive.get('isDarkTheme') ?? await hive.put('isDarkTheme', false);
  hive.get('isLoggedIn') ?? await hive.put('isLoggedIn', false);
  // for initial animation
  hive.get('isIntroSeen') ?? await hive.put('isIntroSeen', false);
  // for intro video after first login
  hive.get('isLoginIntroSeen') ?? await hive.put('isLoginIntroSeen', false);
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('kn'),
        Locale('hi'),
        Locale('ml')
      ],
      path: 'assets/langs',
      fallbackLocale: const Locale('en', 'US'),
      child: AdaptiveTheme(
        light: ThemeConfig.lightTheme,
        dark: ThemeConfig.darkTheme,
        initial: hive.get('isDarkTheme') == true
            ? AdaptiveThemeMode.dark
            : AdaptiveThemeMode.light,
        builder: ((light, dark) => App(
              light: light,
              dark: dark,
              hiveObj: hive,
            )),
      ),
    ),
  );
}

class App extends StatefulWidget {
  final ThemeData light;
  final ThemeData dark;
  final Box hiveObj;
  const App({
    super.key,
    required this.light,
    required this.dark,
    required this.hiveObj,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: widget.light,
      darkTheme: widget.dark,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      //define routes
      routes: {
        '/': (context) => widget.hiveObj.get('isLoggedIn') == true
            ? const Home()
            : widget.hiveObj.get('isIntroSeen') == true
                ? const InitialIntroVideo()
                : const InitialIntroVideo(),
        // '/': (context) => const Home(),
        '/initial-intro': (context) => const InitialIntroVideo(),
        '/login-intro': (context) => const LoginIntroVideo(),
        '/login': (context) => const Login(),
        '/register': (context) => const Register(),
        '/home': (context) => const Home(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(),
        '/upload-files': (context) => const Uploadfiles(),
        '/description': (context) => const Description(),
      },
    );
  }
}
