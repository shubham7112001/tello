import 'package:flutter/material.dart';
import 'package:otper_mobile/utils/constants/app_text_styles.dart';

class AuthTextField extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final bool isPasswordField;
  final bool isRequiredField;
  final String? error;
  final EdgeInsets padding;
  final IconData iconData;

  const AuthTextField({
    super.key,
    this.hint = '',
    required this.onChanged,
    required this.keyboardType,
    required this.iconData,
    this.isPasswordField = false,
    this.isRequiredField = false,
    this.error,
    this.padding = const EdgeInsets.all(0),
  });

  final BorderRadius _borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(12),
        bottomRight: Radius.circular(12)
      );

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: _borderRadius,
      borderSide: const BorderSide(
        color: Colors.blue,   // 👈 Border color
        width: 0.5,             // 👈 Border thickness
      ),
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: _borderRadius,
      borderSide: BorderSide(
        color: Colors.redAccent,   // 👈 Border color
        width: 0.5,             // 👈 Border thickness
      ),
      
    );

    final focussedBorder = OutlineInputBorder(
      borderRadius: _borderRadius,
      borderSide: BorderSide(
        color: Colors.lightBlueAccent,   // 👈 Border color
        width: 1,             // 👈 Border thickness
      ),
      
    );


    return Padding(
      padding: padding,
      child: TextField(
        keyboardType: keyboardType,
        style:Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Opacity(opacity: 0.7, child: Icon(iconData, size: 20)),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 24, 
          ),  
        
          contentPadding: const EdgeInsets.symmetric(horizontal: 40),
          hintText: isRequiredField ? hint : hint,
          border: border,
          disabledBorder: border,
          enabledBorder: border,
          errorBorder: errorBorder,
          focusedErrorBorder: errorBorder,
          focusedBorder: focussedBorder,
          errorStyle: AppTextStyles.errorTextFieldStyle,
          errorText: error?.isNotEmpty == true ? error : null,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintStyle:Theme.of(context).textTheme.bodySmall,
        ),
        autocorrect: false,
        textInputAction: TextInputAction.done,
        obscureText: isPasswordField,
        onChanged: onChanged,
      ),
    );
  }
}
