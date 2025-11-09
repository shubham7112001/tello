import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'zoom_event.dart';
part 'zoom_state.dart';

class ZoomBloc extends Cubit<ZoomState> {
  ZoomBloc() : super(ZoomState(scale: 1.0));

  void reset() {
    debugPrint("reset zoom called");
    emit(ZoomState(scale: 1.0));
  }

  void toggleZoom() {
    final currentScale = state.scale;

    if (currentScale > 0.7) {
      emit(ZoomState(scale: 0.7));
    } else {
      emit(ZoomState(scale: 1.0));
    }
  }

  
}


