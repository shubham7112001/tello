import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:otper_mobile/data/models/home_board_model.dart';

// ----------------- STATE -----------------
class BoardDetailsState extends Equatable {
  final HomeBoardModel board;
  final String description;

  const BoardDetailsState({
    required this.board,
    required this.description,
  });

  BoardDetailsState copyWith({
    HomeBoardModel? board,
    String? description,
  }) {
    return BoardDetailsState(
      board: board ?? this.board,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [board, description];
}

// ----------------- CUBIT -----------------
class BoardDetailsCubit extends Cubit<BoardDetailsState> {
  BoardDetailsCubit(HomeBoardModel board)
      : super(BoardDetailsState(board: board, description: board.description ?? ''));

  void updateDescription(String newDescription) {
    emit(state.copyWith(description: newDescription));
  }

  void saveDescription() {
    final updatedBoard = state.board.copyWith(description: state.description);
    emit(state.copyWith(board: updatedBoard));
  }
}


extension HomeBoardModelCopy on HomeBoardModel {
  HomeBoardModel copyWith({
    String? id,
    String? name,
    String? slug,
    String? key,
    String? description,
  }) {
    return HomeBoardModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      key: key ?? this.key,
      description: description ?? this.description,
    );
  }
}