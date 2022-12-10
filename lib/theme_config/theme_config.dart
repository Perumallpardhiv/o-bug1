import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeConfig {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xffDB4437),
    secondaryHeaderColor: const Color(0xffF4B400),
    appBarTheme: const AppBarTheme(color: Color(0xffDB4437)),
    backgroundColor: Colors.white,
    fontFamily: GoogleFonts.openSans().fontFamily,
    buttonTheme: const ButtonThemeData(buttonColor: Colors.amber),
    switchTheme: SwitchThemeData(
      thumbColor:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return const Color.fromARGB(255, 255, 42, 0).withOpacity(.48);
        }
        return const Color.fromARGB(255, 255, 42, 0);
      }),
      trackColor:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return const Color.fromARGB(238, 227, 130, 85).withOpacity(.48);
        }
        return const Color.fromARGB(238, 227, 130, 85);
      }),
    ),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: Colors.yellow),
    useMaterial3: true,
  );
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xffDB4437),
    appBarTheme: const AppBarTheme(color: Color(0xffDB4437)),
    secondaryHeaderColor: const Color(0xffF4B400),
    backgroundColor: Colors.grey.shade700,
    fontFamily: GoogleFonts.openSans().fontFamily,
    buttonTheme: const ButtonThemeData(buttonColor: Colors.amber),
    switchTheme: SwitchThemeData(
      thumbColor:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return const Color.fromARGB(255, 255, 42, 0).withOpacity(.48);
        }
        return const Color.fromARGB(255, 255, 42, 0);
      }),
      trackColor:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return const Color.fromARGB(238, 227, 130, 85).withOpacity(.48);
        }
        return const Color.fromARGB(238, 227, 130, 85);
      }),
    ),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: Colors.yellow),
    useMaterial3: true,
  );
  static TextStyle textStyle = const TextStyle(color: Colors.white);
}
