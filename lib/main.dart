import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter/services.dart';
import 'package:o_health/screens/home.dart';
import 'package:o_health/screens/login.dart';
import 'package:o_health/screens/register.dart';
import 'package:o_health/theme_config/theme_config.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  var widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await EasyLocalization.ensureInitialized();
  //add license file
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  Hive.init((await getApplicationDocumentsDirectory()).path);
  Box hive = await Hive.openBox('data');
  hive.get('isDarkTheme') ?? hive.put('isDarkTheme', false);
  hive.get('isLoggedIn') ?? hive.put('isLoggedIn', false);
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('kn')],
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
            : const Login(),
        '/login': (context) => const Login(),
        '/register': (context) => const Register(),
        '/home': (context) => const Home()
      },
    );
  }
}
