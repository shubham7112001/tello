import 'package:flutter/material.dart';

class AppIcons {

  static const double defaultSize = 24.0;

  static const Color defaultColor = Colors.grey;
  
  static const IconData name = Icons.person_outline;
  static const IconData username = Icons.account_circle_outlined;
  static const IconData email = Icons.email_outlined;
  static const IconData password = Icons.lock_outline;

  static Icon build(IconData icon,
      {Color color = defaultColor, double size = defaultSize}) {
    return Icon(icon, color: color, size: size);
  }
}
