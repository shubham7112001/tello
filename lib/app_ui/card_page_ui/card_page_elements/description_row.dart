import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_bloc_cubit/card_page_blocs/description_cubit.dart';
import 'package:otper_mobile/utils/app_widgets/app_text_field.dart';

class DescriptionText extends StatelessWidget {
  final IconData icon;
  final String hint;

  const DescriptionText({
    super.key,
    this.icon = Icons.description,
    this.hint = "Enter description",
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DescriptionCubit>();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8.0),
          child: Icon(icon, size: 20, color: Colors.grey.shade700),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AppTextField(
            controller: cubit.controller, // ✅ persistent controller
            autoFocus: false,
            icon: Icons.description,
            hint: hint,
            onChanged: (value) => cubit.update(value),
            minLines: 1,
            maxLines: null,
          ),
        ),
      ],
    );
  }
}
