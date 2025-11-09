import 'package:flutter/material.dart';
import 'package:otper_mobile/utils/theme/auth_background_theme.dart';

class AuthBackGroundWidgets extends StatelessWidget{
  const AuthBackGroundWidgets({super.key, required this.child});

  final Widget child;
  
  @override
  Widget build(BuildContext context) {
    final gradient = Theme.of(context).extension<AuthBackgroundTheme>()!.backgroundGradient;
    return Container(
          decoration: BoxDecoration(
            gradient: gradient
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(38.0, 0, 38.0, 8.0),
            child:child,
          ),
        );
      
  }
}