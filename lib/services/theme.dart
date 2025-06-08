import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// Color primaryColor = const Color(0xFF941f37);
// Color secondaryColor = const Color(0xFF941f37).withOpacity(.47);
Color primaryColor = const Color(0xff09596F);
Color secondaryColor = const Color(0xff2a4e57);
Color backgroundDark = const Color(0xff231F20);
Color backgroundLight = const Color(0xffffffff);

const Color textPrimary = Color(0xff000000);
const Color textSecondary = Color(0xffffffff);
Map<int, Color> color = const {
  50: Color.fromRGBO(255, 244, 149, .1),
  100: Color.fromRGBO(255, 244, 149, .2),
  200: Color.fromRGBO(255, 244, 149, .3),
  300: Color.fromRGBO(255, 244, 149, .4),
  400: Color.fromRGBO(255, 244, 149, .5),
  500: Color.fromRGBO(255, 244, 149, .6),
  600: Color.fromRGBO(255, 244, 149, .7),
  700: Color.fromRGBO(255, 244, 149, .8),
  800: Color.fromRGBO(255, 244, 149, .9),
  900: Color.fromRGBO(255, 244, 149, 1),
};
MaterialColor colorCustom = MaterialColor(0XFFFFF495, color);

class CustomTheme {
  static ThemeData light = ThemeData(

    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundLight,
    hintColor: Colors.grey[700],
    primarySwatch: colorCustom,
    canvasColor: secondaryColor,
    primaryColorLight: secondaryColor,
    splashColor: Colors.grey.withOpacity(0.2),
    shadowColor: Colors.grey[600],
    cardColor: Colors.grey[100],
    primaryColor: primaryColor,
    dividerColor: Colors.grey[600],
    primaryColorDark: Colors.black,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.black,
      error: const Color(0xFFCF6679),
      onError: const Color(0xFFCF6679),
      background: backgroundLight,
      onBackground: Colors.black,
      surface: backgroundLight,
      onSurface: Colors.black,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      actionsIconTheme: IconThemeData(
        color: backgroundLight,
      ),
      iconTheme: IconThemeData(
        color: backgroundLight,
      ),
      surfaceTintColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: Colors.transparent,
        systemStatusBarContrastEnforced: true
        // Status bar brightness (optional)
        // statusBarIconBrightness: Brightness.light,
        // statusBarBrightness: Brightness.light,
      ),
    ),
    typography: Typography.material2021(),
    textTheme: TextTheme(
      labelLarge: GoogleFonts.poppins(

      ),
      labelMedium: GoogleFonts.poppins(),
      labelSmall: GoogleFonts.poppins(),
      headlineLarge: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        color: textSecondary,
        fontSize: 17.0,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        color: textSecondary,
        fontSize: 17.0,
      ),
      headlineSmall: GoogleFonts.poppins(),
      displayLarge:
          GoogleFonts.poppins(fontSize: 27, fontWeight: FontWeight.w600),
      displayMedium: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      titleLarge: GoogleFonts.poppins(),
      titleMedium: GoogleFonts.poppins(),
      titleSmall: GoogleFonts.poppins(),
      bodyLarge: GoogleFonts.poppins(),
      bodyMedium: GoogleFonts.poppins(),
      bodySmall: GoogleFonts.poppins(),
    ),
  );
  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundDark,
    hintColor: Colors.grey[700],
    primarySwatch: colorCustom,
    canvasColor: secondaryColor,
    primaryColorLight: secondaryColor,
    splashColor: secondaryColor,
    shadowColor: Colors.black45,
    cardColor: Colors.grey[800],
    primaryColor: primaryColor,
    dividerColor: Colors.grey[200],
    primaryColorDark: Colors.white,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.black,
      error: const Color(0xFFCF6679),
      onError: const Color(0xFFCF6679),
      background: backgroundDark,
      onBackground: Colors.white,
      surface: backgroundDark,
      onSurface: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      actionsIconTheme: IconThemeData(
        color: backgroundLight,
      ),
      iconTheme: IconThemeData(
        color: backgroundLight,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: primaryColor,
        // Status bar brightness (optional)
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    ),
    typography: Typography.material2021(),
    textTheme: TextTheme(
      labelLarge: GoogleFonts.openSans(
        fontWeight: FontWeight.w400,
        color: textSecondary,
        fontSize: 14.0,
      ),
      headlineLarge: GoogleFonts.openSans(),
      headlineMedium: GoogleFonts.openSans(),
      headlineSmall: GoogleFonts.openSans(),
      displayLarge: GoogleFonts.openSans(),
      displayMedium: GoogleFonts.openSans(),
      displaySmall: GoogleFonts.openSans(),
      titleLarge: GoogleFonts.openSans(),
      titleMedium: GoogleFonts.openSans(),
      titleSmall: GoogleFonts.openSans(),
      bodyLarge: GoogleFonts.openSans(),
      bodyMedium: GoogleFonts.openSans(),
      bodySmall: GoogleFonts.openSans(),
    ),
  );
}
