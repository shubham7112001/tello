import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class NameColorState extends Equatable {
  final String name;
  final Color color;

  const NameColorState({this.name = "", this.color = Colors.blue});

  NameColorState copyWith({String? name, Color? color}) {
    return NameColorState(
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [name, color];
}

class NameColorCubit extends Cubit<NameColorState> {
  NameColorCubit(String initialName, Color initialColor)
      : super(NameColorState(name: initialName, color: initialColor));

  void updateName(String name) => emit(state.copyWith(name: name));
  void updateColor(Color color) => emit(state.copyWith(color: color));
}
