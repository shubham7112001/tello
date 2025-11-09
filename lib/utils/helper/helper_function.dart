import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otper_mobile/main.dart';
import 'package:otper_mobile/utils/constants/app_text_styles.dart';

class HelperFunction {

 static  void showAppSnackBar({
    required String message,
    Color backgroundColor = Colors.black87,
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger = rootScaffoldMessengerKey.currentState;
    messenger?.hideCurrentSnackBar();
    messenger?.showSnackBar(
      SnackBar(
        content: Text(message, style: AppTextStyles.labelLargeDark,),
        backgroundColor: backgroundColor,
        duration: duration,
      ),
    );
  }

  static Color parseColor(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) {
      return Colors.transparent;
    }

    hexColor = hexColor.replaceAll("#", "");

    // Check if the string is a valid hex number (6 or 8 characters)
    if (!RegExp(r'^[0-9a-fA-F]{6}$|^[0-9a-fA-F]{8}$').hasMatch(hexColor)) {
      return Colors.transparent;
    }

    // If it's 6 characters, prepend FF for full opacity
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }

    return Color(int.parse(hexColor, radix: 16));
  }


  static Future<void> showCustomDialog({
    required BuildContext context,
    required Widget child,
    ShapeBorder? shape,
    double? width,
    double? height,
    bool useIntrinsic = true
  }) {
    return showDialog(      
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: shape ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          child: Material(
            color: Colors.transparent,
            type: MaterialType.transparency,
            child: useIntrinsic ?
            IntrinsicWidth(
              child: IntrinsicHeight(
                child: child,
              ),
            )
            :SizedBox(
              child: child, 
            ),
          ),
        );
      },
    );
  }

  static String getTodaysDay() {
    final now = DateTime.now();
    return DateFormat('EEEE').format(now);
  }

  static String formatToReadableDateTime(DateTime? dt) {
    if (dt == null) return "--";

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final date = DateTime(dt.year, dt.month, dt.day);

    String dayString;
    if (date == today) {
      dayString = "Today";
    } else if (date == tomorrow) {
      dayString = "Tomorrow";
    } else {
      dayString = DateFormat('EEEE, d MMMM yyyy').format(dt); // Monday, 29 September 2025
    }

    String timeString = DateFormat('HH:mm').format(dt); // 24-hour format, e.g., 10:00

    return "$dayString at $timeString";
  }

  static Color getTextColor(Color backgroundColor) {
    double luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  static String colorToHex(Color color) {
  return "#${color.value.toRadixString(16).substring(2).toUpperCase()}";
}

}