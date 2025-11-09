import 'package:flutter/material.dart';
import 'package:otper_mobile/utils/constants/app_colors.dart';
import 'package:otper_mobile/utils/constants/app_text_styles.dart';
import 'package:otper_mobile/utils/theme/auth_background_theme.dart';
import 'package:otper_mobile/utils/theme/icon_theme.dart';
import 'package:otper_mobile/utils/theme/main_background_theme.dart';

class AppTheme {
  
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Poppins',
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.scaffoldBgLight,
    appBarTheme: AppBarTheme(          // 👈 AppBar background
      backgroundColor: AppColors.appMainColor,
      foregroundColor: AppColors.darkBackgroundThemeColor,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white, // Text color for light theme
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: AppTextStyles.light, 
    extensions: [
      AuthBackgroundTheme(
        backgroundGradient: AppColors.authBGforLightTheme,
      ),
      MainBackgroundTheme(
        backgroundGradient: AppColors.authBGforLightTheme,
      ),
      AppIconTheme.light
    ],
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.scaffoldBgDark,
    appBarTheme: AppBarTheme(     
      backgroundColor: AppColors.appMainColor,
      foregroundColor: AppColors.lightBackgroundThemeColor,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white, // Text color for dark theme
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    iconTheme: IconThemeData(color: Colors.white), 
    ),
    textTheme: AppTextStyles.dark,
    extensions: [
      AuthBackgroundTheme(
        backgroundGradient: AppColors.authBGforDarkTheme,
      ),
      MainBackgroundTheme(
        backgroundGradient: AppColors.authBGforDarkTheme,
      ),
      AppIconTheme.dark
    ],
  );
}