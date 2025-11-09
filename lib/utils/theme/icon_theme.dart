import 'package:flutter/material.dart';

enum IconSize { verySmall, small, medium, large, extraLarge }

class AppIconTheme extends ThemeExtension<AppIconTheme> {
  final Color color;
  final Map<IconSize, double> sizes;

  const AppIconTheme({
    required this.color,
    required this.sizes,
  });

  // Default light theme
  static const light = AppIconTheme(
    color: Colors.black,
    sizes: {
      IconSize.verySmall: 8,
      IconSize.small: 12,
      IconSize.medium: 16,
      IconSize.large: 24,
      IconSize.extraLarge: 32,
    },
  );

  // Default dark theme
  static const dark = AppIconTheme(
    color: Colors.white,
    sizes: {
      IconSize.verySmall: 8,
      IconSize.small: 12,
      IconSize.medium: 16,
      IconSize.large: 24,
      IconSize.extraLarge: 32,
    },
  );

  @override
  AppIconTheme copyWith({Color? color, Map<IconSize, double>? sizes}) {
    return AppIconTheme(
      color: color ?? this.color,
      sizes: sizes ?? this.sizes,
    );
  }

  @override
  AppIconTheme lerp(ThemeExtension<AppIconTheme>? other, double t) {
    if (other is! AppIconTheme) return this;
    return AppIconTheme(
      color: Color.lerp(color, other.color, t)!,
      sizes: sizes, // sizes usually stay constant
    );
  }
}
