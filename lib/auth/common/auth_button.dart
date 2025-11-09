import 'package:flutter/material.dart';
import 'package:otper_mobile/utils/constants/app_text_styles.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30), // padding included here
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(Radius.circular(8))
          ),
          child: Center(
            child: Text(
              text,
              style:Theme.of(context).textTheme.labelLarge
            ),
          ),
        ),
      ),
    );
  }
}
