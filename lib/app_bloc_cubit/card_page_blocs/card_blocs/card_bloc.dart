import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/data/models/card_model.dart';
import 'package:otper_mobile/data/repositories/card_repository.dart';
import 'card_event.dart';
import 'card_state.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  CardBloc() : super(CardInitial()) {
    on<FetchCardEvent>(_onFetchCard);
  }

  Future<void> _onFetchCard(FetchCardEvent event, Emitter<CardState> emit) async {
    emit(CardLoading());

    try {
      final result = await CardRepository.getCardBySlug(event.slug);

      if (result.hasException) {
        emit(CardError(result.exception.toString()));
        return;
      }

      CardModel? cardData = CardModel.fromJson(result.data?['cardBySlug']);

      debugPrint("Card Data : $cardData");

      if (cardData == null) {
        emit(const CardError('Card not found'));
        return;
      }

      emit(CardLoaded(cardData));
    } catch (e) {
      emit(CardError(e.toString()));
    }
  }
}
