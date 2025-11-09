import 'package:flutter/material.dart';
import 'package:otper_mobile/utils/theme/main_background_theme.dart';

class AppBackgroundWidgets extends StatelessWidget {
  final Widget child;
  const AppBackgroundWidgets({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final gradient = Theme.of(context).extension<MainBackgroundTheme>()!.backgroundGradient;
    return Container(
          decoration: BoxDecoration(
            gradient: gradient
          ),
          child: child,
        );
      
  }
}