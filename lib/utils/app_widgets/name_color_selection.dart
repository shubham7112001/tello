import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:otper_mobile/app_bloc_cubit/utils/name_color_cubit.dart';

class NameColorDialog extends StatelessWidget {
  final String title;
  final String initialName;
  final Color initialColor;
  final void Function(String name, Color color) onSave;

  const NameColorDialog({
    super.key,
    required this.title,
    required this.initialName,
    required this.initialColor,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NameColorCubit(initialName, initialColor),
      child: BlocBuilder<NameColorCubit, NameColorState>(
        builder: (context, state) {
          return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: TextEditingController(text: state.name)
                    ..selection = TextSelection.fromPosition(
                      TextPosition(offset: state.name.length),
                    ),
                  decoration: const InputDecoration(labelText: "Name"),
                  onChanged: (val) =>
                      context.read<NameColorCubit>().updateName(val),
                ),
                const SizedBox(height: 10),
                BlockPicker(
                  pickerColor: state.color,
                  onColorChanged: (color) =>
                      context.read<NameColorCubit>().updateColor(color),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel")),
              ElevatedButton(
                onPressed: () {
                  if (state.name.trim().isEmpty) return;
                  onSave(state.name.trim(), state.color);
                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
            ],
          );
        },
      ),
    );
  }
}
