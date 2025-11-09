part of 'board_bloc.dart';

abstract class BoardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BoardInitial extends BoardState {}

class BoardLoading extends BoardState {}

class BoardLoaded extends BoardState {
  final AppFlowyBoardController controller;
  final List<AppFlowyGroupData> groups;

  BoardLoaded({required this.controller, required this.groups});

  @override
  List<Object?> get props => [groups];
}

class BoardError extends BoardState {
  final String message;

  BoardError({required this.message});

  @override
  List<Object?> get props => [message];
}
