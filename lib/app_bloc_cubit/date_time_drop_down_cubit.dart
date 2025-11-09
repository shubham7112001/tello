import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class DateTimeDropdownState {
  final DateTime? selectedDateTime;
  final bool isRowVisible;

  const DateTimeDropdownState({this.selectedDateTime, this.isRowVisible = false});

  DateTimeDropdownState copyWith({DateTime? selectedDateTime, bool? isRowVisible}) {
    return DateTimeDropdownState(
      selectedDateTime: selectedDateTime ?? this.selectedDateTime,
      isRowVisible: isRowVisible ?? this.isRowVisible,
    );
  }
}

class DateTimeDropdownCubit extends Cubit<DateTimeDropdownState> {
  DateTimeDropdownCubit({DateTime? initialDateTime})
      : super(DateTimeDropdownState(
          selectedDateTime: initialDateTime,
          isRowVisible: initialDateTime != null,
        ));

  void showRow() {
    emit(state.copyWith(isRowVisible: true));
  }

  void hideRow() {
    emit(state.copyWith(isRowVisible: false, selectedDateTime: null));
  }

  void updateDateTime(DateTime dateTime) {
    log("Emitted updateDatetime");
    emit(state.copyWith(selectedDateTime: dateTime));
  }
}


