import 'package:flutter/material.dart';
import 'package:otper_mobile/utils/constants/app_text_styles.dart';

class AuthBottomText extends StatelessWidget {
  const AuthBottomText({
    super.key,
    required this.text,
    required this.onPressed,
    required this.buttonText,
  });

  final String text;
  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.titleSmall
            ),
            TextButton(
              onPressed: onPressed,
              child: Text(
                buttonText,
                style: AppTextStyles.textButtonStyle
              ),
            ),
          ],
        ),
      ),
    );
  }
}
