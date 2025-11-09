import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DescriptionCubit extends Cubit<String> {
  final TextEditingController controller;

  DescriptionCubit({String initial = ""})
      : controller = TextEditingController(text: initial),
        super(initial) {
    controller.addListener(() {
      emit(controller.text);
    });
  }

  void update(String value) {
    if (controller.text != value) {
      controller.text = value;
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );
    }
  }

  @override
  Future<void> close() {
    controller.dispose();
    return super.close();
  }
}