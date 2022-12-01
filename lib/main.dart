import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:o_health/screens/home.dart';
import 'package:o_health/theme_config/theme_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //add license file
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  runApp(MaterialApp(
    theme: ThemeConfig.lightTheme,
    darkTheme: ThemeConfig.darkTheme,
    themeMode: ThemeMode.system,
    //define routes
    routes: {
      '/': (context) => const App(),
      '/home': (context) => const Home(),
    },
  ));
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 2000,
      splash: Icons.home,
      nextScreen: const Home(),
    );
  }
}
