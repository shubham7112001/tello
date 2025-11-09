import 'package:flutter_bloc/flutter_bloc.dart';

class BoardDrawerState {
  final int? selectedIndex;
  BoardDrawerState({this.selectedIndex});

  BoardDrawerState copyWith({int? selectedIndex}) {
    return BoardDrawerState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}

class BoardDrawerCubit extends Cubit<BoardDrawerState> {
  BoardDrawerCubit() : super(BoardDrawerState());

  void selectItem(int index) => emit(state.copyWith(selectedIndex: index));
}