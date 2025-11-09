import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final IconData? icon;
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final int minLines;
  final int? maxLines;
  final bool keepFocusOnSubmit;
  final FocusNode? focusNode;
  final bool autoFocus;

  const AppTextField({
    super.key,
    this.icon = Icons.description,
    this.hint = "Enter text",
    this.controller,
    this.onChanged,
    this.minLines = 1,
    this.maxLines,
    this.onSubmitted,
    this.keepFocusOnSubmit = false,
    this.focusNode,
    this.autoFocus = false
  });

  @override
  Widget build(BuildContext context) {
    final textController = controller ?? TextEditingController();
    final node = focusNode ?? FocusNode();

    if (autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!node.hasFocus) {
          node.requestFocus();
        }
      });
    }

    textController.selection = TextSelection.fromPosition( TextPosition(offset: textController.text.length), );

    return TextField(
      focusNode: node,
      autofocus: true,
      onSubmitted: (value) {
        onSubmitted?.call(value);

        if (keepFocusOnSubmit) {
          node.requestFocus(); // keep focus
        } else {
          node.unfocus(); // default behavior
        }
      },
      style: Theme.of(context).textTheme.labelSmall,
      controller: textController,
      keyboardType: TextInputType.multiline,
      minLines: minLines,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        border: const UnderlineInputBorder(),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        hintStyle: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}