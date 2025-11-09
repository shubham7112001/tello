
import 'package:flutter/material.dart';

class AppColors {
  static Color appMainColor =  Color(0xFF19338c);
  static Color appMainSoftColor = Color(0xFF2230B3);
  
  static Color darkBackgroundThemeColor = Colors.black26;
  static Color lightBackgroundThemeColor = Colors.white;

  static Color lightTextTheme = Colors.black;
  static Color darkTextTheme = Colors.white;

  // static Color cardBg = Colors.deepPurple;
  static Color cardBg = Color.fromARGB(255, 38, 39, 50) ;

  // GRADIENTS

  static LinearGradient authBGforDarkTheme = LinearGradient(
    colors: [Color(0xFF0A192F), Color(0xFF1E2A47)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient authBGforLightTheme = LinearGradient(
    colors: [
      Color(0xFFEEEEEE),
      Color(0xFFE8E8E8),
      Color(0xFFE2E2E2),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // BOARD

  static const Color groupBgDark = Color.fromARGB(255, 113, 108, 108);
  static const Color groupBgLight = Color(0xFFF5F5F5);

  static Color groupBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? groupBgDark
        : groupBgLight;
  }

  static Color cardPageElementLight = const Color.fromARGB(179, 237, 237, 237);
  static Color cardPageElementDark = const Color.fromARGB(134, 53, 53, 53);

  static Color scaffoldBgLight = Color(0xFFFFFFFF);
  static Color scaffoldBgDark = Color(0xFF000000);

  static Color listBackgroundLight = Color(0xFFf1f2f4);
  static Color listBackgroundDark = Color(0xFF202223);
}