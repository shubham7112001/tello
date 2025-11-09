part of 'board_bloc.dart';

abstract class BoardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadBoardEvent extends BoardEvent {
  final HomeBoardModel board;
  LoadBoardEvent({required this.board});
}

class MoveGroupItemEvent extends BoardEvent {
  final String groupId;
  final int fromIndex;
  final int toIndex;

  MoveGroupItemEvent({required this.groupId, required this.fromIndex, required this.toIndex});
}

class MoveGroupEvent extends BoardEvent {
  final int fromIndex;
  final int toIndex;

  MoveGroupEvent({required this.fromIndex, required this.toIndex});
}

class MoveGroupItemToGroupEvent extends BoardEvent {
  final String fromGroupId;
  final int fromIndex;
  final String toGroupId;
  final int toIndex;

  MoveGroupItemToGroupEvent({
    required this.fromGroupId,
    required this.fromIndex,
    required this.toGroupId,
    required this.toIndex,
  });
}

class AddCardEvent extends BoardEvent {
  final String listId;
  final String title;
  final String? description;

  AddCardEvent({
    required this.listId,
    required this.title,
    required this.description,
  });

  @override
  List<Object> get props => [listId, title, description ?? ''];
}

