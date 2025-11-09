import 'package:flutter/material.dart';

class AuthBackgroundTheme extends ThemeExtension<AuthBackgroundTheme> {
  final Gradient backgroundGradient;

  const AuthBackgroundTheme({required this.backgroundGradient});

  @override
  AuthBackgroundTheme copyWith({Gradient? backgroundGradient}) {
    return AuthBackgroundTheme(
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
    );
  }

  @override
  AuthBackgroundTheme lerp(ThemeExtension<AuthBackgroundTheme>? other, double t) {
    if (other is! AuthBackgroundTheme) return this;
    return AuthBackgroundTheme(
      backgroundGradient: Gradient.lerp(backgroundGradient, other.backgroundGradient, t)!,
    );
  }
}
