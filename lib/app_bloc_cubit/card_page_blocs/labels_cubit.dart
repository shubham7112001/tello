import 'package:flutter_bloc/flutter_bloc.dart';

class LabelsCubit extends Cubit<bool> {
  LabelsCubit() : super(false);

  void toggle() => emit(!state);
}