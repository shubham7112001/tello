import 'package:flutter/material.dart';
import 'package:otper_mobile/utils/constants/app_text_styles.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({super.key, required this.text}) ;

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0, top: 30.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineSmall
      ),
    );
  }
}
