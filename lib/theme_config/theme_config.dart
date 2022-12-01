import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeConfig {
  static final ThemeData lightTheme = FlexThemeData.light(
    scheme: FlexScheme.flutterDash,
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 20,
    appBarOpacity: 0.95,
    swapColors: true,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 20,
      blendOnColors: false,
      toggleButtonsRadius: 10.0,
      fabRadius: 38.0,
      fabSchemeColor: SchemeColor.inversePrimary,
      chipRadius: 4.0,
      tabBarItemSchemeColor: SchemeColor.onPrimary,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    fontFamily: GoogleFonts.openSans().fontFamily,
  );

  static final darkTheme = FlexThemeData.dark(
    scheme: FlexScheme.flutterDash,
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 15,
    appBarStyle: FlexAppBarStyle.background,
    appBarOpacity: 0.90,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 30,
      toggleButtonsRadius: 10.0,
      fabRadius: 38.0,
      fabSchemeColor: SchemeColor.inversePrimary,
      chipRadius: 4.0,
    ),
    useMaterial3: true,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    fontFamily: GoogleFonts.openSans().fontFamily,
  );
}
