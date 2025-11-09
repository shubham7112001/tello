import 'package:flutter/material.dart';
import 'package:otper_mobile/utils/constants/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();
  
  static TextStyle textButtonStyle = TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.blue);
  static TextStyle errorTextFieldStyle = TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.redAccent);

  static TextStyle smallBlueText = TextStyle(fontSize: 10.0, fontWeight: FontWeight.w500, color: Colors.blue);


  // ------------------ LIGHT THEME ------------------ //
  static const double _headlineLargeSize = 32.0;
  static const double _headlineMediumSize = 24.0;
  static const double _headlineSmallSize = 18.0;

  static const double _titleLargeSize = 16.0;
  static const double _titleMediumSize = 16.0;
  static const double _titleSmallSize = 16.0;

  static const double _bodyLargeSize = 14.0;
  static const double _bodyMediumSize = 14.0;
  static const double _bodySmallSize = 14.0;

  static const double _labelLargeSize = 12.0;
  static const double _labelMediumSize = 12.0;

  // Light TextStyles
  static final TextStyle headlineLargeLight = TextStyle(
      fontSize: _headlineLargeSize,
      fontWeight: FontWeight.bold,
      color: AppColors.lightTextTheme);
  static final TextStyle headlineMediumLight = TextStyle(
      fontSize: _headlineMediumSize,
      fontWeight: FontWeight.w600,
      color: AppColors.lightTextTheme);
  static final TextStyle headlineSmallLight = TextStyle(
      fontSize: _headlineSmallSize,
      fontWeight: FontWeight.w600,
      color: AppColors.lightTextTheme);

  static final TextStyle titleLargeLight = TextStyle(
      fontSize: _titleLargeSize,
      fontWeight: FontWeight.w600,
      color: AppColors.lightTextTheme);
  static final TextStyle titleMediumLight = TextStyle(
      fontSize: _titleMediumSize,
      fontWeight: FontWeight.w500,
      color: AppColors.lightTextTheme);
  static final TextStyle titleSmallLight = TextStyle(
      fontSize: _titleSmallSize,
      fontWeight: FontWeight.w400,
      color: AppColors.lightTextTheme);

  static final TextStyle bodyLargeLight = TextStyle(
      fontSize: _bodyLargeSize,
      fontWeight: FontWeight.w500,
      color: AppColors.lightTextTheme);
  static final TextStyle bodyMediumLight = TextStyle(
      fontSize: _bodyMediumSize,
      fontWeight: FontWeight.normal,
      color: AppColors.lightTextTheme);
  static final TextStyle bodySmallLight = TextStyle(
      fontSize: _bodySmallSize,
      fontWeight: FontWeight.w500,
      color: AppColors.lightTextTheme.withOpacity(0.5));

  static final TextStyle labelLargeLight = TextStyle(
      fontSize: _labelLargeSize,
      fontWeight: FontWeight.normal,
      color: AppColors.lightTextTheme);
  static final TextStyle labelMediumLight = TextStyle(
      fontSize: _labelMediumSize,
      fontWeight: FontWeight.normal,
      color: AppColors.lightTextTheme.withOpacity(0.5));

  static final TextTheme light = TextTheme(
    headlineLarge: headlineLargeLight,
    headlineMedium: headlineMediumLight,
    headlineSmall: headlineSmallLight,
    titleLarge: titleLargeLight,
    titleMedium: titleMediumLight,
    titleSmall: titleSmallLight,
    bodyLarge: bodyLargeLight,
    bodyMedium: bodyMediumLight,
    bodySmall: bodySmallLight,
    labelLarge: labelLargeLight,
    labelMedium: labelMediumLight,
  );

  // ------------------ DARK THEME ------------------ //
  static final TextStyle headlineLargeDark = TextStyle(
      fontSize: _headlineLargeSize,
      fontWeight: FontWeight.bold,
      color: AppColors.darkTextTheme);
  static final TextStyle headlineMediumDark = TextStyle(
      fontSize: _headlineMediumSize,
      fontWeight: FontWeight.w600,
      color: AppColors.darkTextTheme);
  static final TextStyle headlineSmallDark = TextStyle(
      fontSize: _headlineSmallSize,
      fontWeight: FontWeight.w600,
      color: AppColors.darkTextTheme);

  static final TextStyle titleLargeDark = TextStyle(
      fontSize: _titleLargeSize,
      fontWeight: FontWeight.w600,
      color: AppColors.darkTextTheme);
  static final TextStyle titleMediumDark = TextStyle(
      fontSize: _titleMediumSize,
      fontWeight: FontWeight.w500,
      color: AppColors.darkTextTheme);
  static final TextStyle titleSmallDark = TextStyle(
      fontSize: _titleSmallSize,
      fontWeight: FontWeight.w400,
      color: AppColors.darkTextTheme);

  static final TextStyle bodyLargeDark = TextStyle(
      fontSize: _bodyLargeSize,
      fontWeight: FontWeight.w500,
      color: AppColors.darkTextTheme);
  static final TextStyle bodyMediumDark = TextStyle(
      fontSize: _bodyMediumSize,
      fontWeight: FontWeight.normal,
      color: AppColors.darkTextTheme);
  static final TextStyle bodySmallDark = TextStyle(
      fontSize: _bodySmallSize,
      fontWeight: FontWeight.w500,
      color: AppColors.darkTextTheme.withOpacity(0.5));

  static final TextStyle labelLargeDark = TextStyle(
      fontSize: _labelLargeSize,
      fontWeight: FontWeight.normal,
      color: AppColors.darkTextTheme);
  static final TextStyle labelMediumDark = TextStyle(
      fontSize: _labelMediumSize,
      fontWeight: FontWeight.normal,
      color: AppColors.darkTextTheme.withOpacity(0.5));

  static final TextTheme dark = TextTheme(
    headlineLarge: headlineLargeDark,
    headlineMedium: headlineMediumDark,
    headlineSmall: headlineSmallDark,
    titleLarge: titleLargeDark,
    titleMedium: titleMediumDark,
    titleSmall: titleSmallDark,
    bodyLarge: bodyLargeDark,
    bodyMedium: bodyMediumDark,
    bodySmall: bodySmallDark,
    labelLarge: labelLargeDark,
    labelMedium: labelMediumDark,
  );
}