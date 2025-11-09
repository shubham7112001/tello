import 'package:flutter/material.dart';

class MainBackgroundTheme extends ThemeExtension<MainBackgroundTheme> {
  final Gradient backgroundGradient;

  const MainBackgroundTheme({required this.backgroundGradient});

  @override
  MainBackgroundTheme copyWith({Gradient? backgroundGradient}) {
    return MainBackgroundTheme(
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
    );
  }

  @override
  MainBackgroundTheme lerp(ThemeExtension<MainBackgroundTheme>? other, double t) {
    if (other is! MainBackgroundTheme) return this;
    return MainBackgroundTheme(
      backgroundGradient: Gradient.lerp(backgroundGradient, other.backgroundGradient, t)!,
    );
  }
}