import 'package:equatable/equatable.dart';
import 'package:otper_mobile/data/models/card_model.dart';

abstract class CardState extends Equatable {
  const CardState();

  @override
  List<Object?> get props => [];
}

class CardInitial extends CardState {}

class CardLoading extends CardState {}

class CardLoaded extends CardState {
  final CardModel card;

  const CardLoaded(this.card);

  @override
  List<Object?> get props => [card];
}

class CardError extends CardState {
  final String message;

  const CardError(this.message);

  @override
  List<Object?> get props => [message];
}
