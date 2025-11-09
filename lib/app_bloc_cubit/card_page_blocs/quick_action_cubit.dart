import 'package:flutter_bloc/flutter_bloc.dart';

class QuickActionsCubit extends Cubit<bool> {
  QuickActionsCubit() : super(false); // false = collapsed

  void toggle() => emit(!state);
}