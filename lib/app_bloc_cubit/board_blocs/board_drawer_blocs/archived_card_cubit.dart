import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_graphql/graph_service.dart';
import 'package:otper_mobile/utils/helper/helper_function.dart';

class ArchivedCardModel {
  final String cardNumber;
  final String title;
  final String id;
  final DateTime archivedAt;

  ArchivedCardModel({
    required this.cardNumber,
    required this.title,
    required this.id,
    required this.archivedAt,
  });

  factory ArchivedCardModel.fromJson(Map<String, dynamic> json) {
    return ArchivedCardModel(
      id: json["id"] as String,
      cardNumber: json["card_number"]?.toString() ?? "",
      title: json["title"] ?? "",
      archivedAt: DateTime.tryParse(json["archived_at"] ?? "") ?? DateTime.now(),
    );
  }
}

abstract class ArchivedCardsState {}

class ArchivedCardsLoading extends ArchivedCardsState {}

class ArchivedCardsLoaded extends ArchivedCardsState {
  final List<ArchivedCardModel> cards;
  final List<ArchivedCardModel> allCards;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;

  ArchivedCardsLoaded({
    required this.cards,
    required this.allCards,
    required this.currentPage,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  ArchivedCardsLoaded copyWith({
    List<ArchivedCardModel>? cards,
    List<ArchivedCardModel>? allCards,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ArchivedCardsLoaded(
      cards: cards ?? this.cards,
      allCards: allCards ?? this.allCards,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class ArchivedCardsError extends ArchivedCardsState {
  final String message;
  ArchivedCardsError(this.message);
}

const String boardBySlugQuery = r'''
  query BoardBySlug($slug: String!, $first: Int!, $page: Int!) {
    boardBySlug(slug: $slug) {
      archivedCards(first: $first, page: $page) {
        data {
          id
          title
          card_number
          archived_at
        }
        paginatorInfo {
          currentPage
          hasMorePages
          total
        }
      }
    }
  }
''';

class ArchivedCardsCubit extends Cubit<ArchivedCardsState> {
  ArchivedCardsCubit() : super(ArchivedCardsLoading());

  static const int _pageSize = 10;
  bool _isLoadingMore = false;

  Future<void> fetchArchivedCards(String slug, {int page = 1}) async {
    try {
      // Only show loading for first page
      if (page == 1) {
        emit(ArchivedCardsLoading());
      }

      final result = await GraphQLService.callGraphQL(
        query: boardBySlugQuery,
        variables: {"slug": slug, "first": _pageSize, "page": page},
      );

      if (result.hasException || result.data == null) {
        if (page == 1) {
          emit(ArchivedCardsError("Failed to load archived cards"));
        } else {
          // For pagination errors, keep current state but stop loading
          if (state is ArchivedCardsLoaded) {
            final current = state as ArchivedCardsLoaded;
            emit(current.copyWith(isLoadingMore: false));
          }
        }
        return;
      }

      final data = result.data!["boardBySlug"]["archivedCards"]["data"] as List<dynamic>;
      final paginator = result.data!["boardBySlug"]["archivedCards"]["paginatorInfo"];

      final newCards = data.map((e) => ArchivedCardModel.fromJson(e)).toList();

      if (state is ArchivedCardsLoaded && page > 1) {
        // Pagination: append new cards
        final current = state as ArchivedCardsLoaded;
        final allCards = [...current.allCards, ...newCards];

        emit(ArchivedCardsLoaded(
          cards: allCards,
          allCards: allCards,
          currentPage: paginator["currentPage"] as int,
          hasMore: paginator["hasMorePages"] as bool,
          isLoadingMore: false, // Reset loading state
        ));
      } else {
        // First load: replace all cards
        emit(ArchivedCardsLoaded(
          cards: newCards,
          allCards: newCards,
          currentPage: paginator["currentPage"] as int,
          hasMore: paginator["hasMorePages"] as bool,
          isLoadingMore: false,
        ));
      }
    } catch (e) {
      if (page == 1) {
        emit(ArchivedCardsError("Exception: $e"));
      } else {
        // For pagination errors, keep current state but stop loading
        if (state is ArchivedCardsLoaded) {
          final current = state as ArchivedCardsLoaded;
          emit(current.copyWith(isLoadingMore: false));
        }
      }
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> loadMore(String slug) async {
    if (state is! ArchivedCardsLoaded) return;
    
    final current = state as ArchivedCardsLoaded;

    // Prevent duplicate calls and check if more data available
    if (!current.hasMore || current.isLoadingMore || _isLoadingMore) {
      return;
    }

    _isLoadingMore = true;

    // Show loading indicator
    emit(current.copyWith(isLoadingMore: true));

    try {
      // Fetch next page
      await fetchArchivedCards(slug, page: current.currentPage + 1);
    } catch (e) {
      // Handle any unexpected errors
      emit(current.copyWith(isLoadingMore: false));
      _isLoadingMore = false;
    }
  }

  void searchCards(String query) {
    log("Current ArchivedCardsState: ${state.runtimeType}");
    if (state is! ArchivedCardsLoaded) return;
    
    final current = state as ArchivedCardsLoaded;

    if (query.isEmpty) {
      emit(current.copyWith(cards: current.allCards));
    } else {
      final filtered = current.allCards
          .where((card) =>
              card.title.toLowerCase().contains(query.toLowerCase()) ||
              card.cardNumber.toLowerCase().contains(query.toLowerCase()))
          .toList();

      emit(current.copyWith(cards: filtered));
    }
  }

  Future<void> unarchiveCard(String cardId) async {
    if (state is! ArchivedCardsLoaded) return;

    final currentState = state as ArchivedCardsLoaded;

    // Optimistic UI update: remove the card immediately
    final updatedCards =
        currentState.allCards.where((c) => c.id != cardId).toList();

    emit(currentState.copyWith(cards: updatedCards, allCards: updatedCards));

    const String mutation = r'''
    mutation UpdateCard($input: UpdateCardInput!) {
      updateCard(input: $input) {
        id
        archived_at
      }
    }
  ''';

  final variables = {
    "input": {
      "id": cardId,
      "archived_at": null,
    }
  };

    try {
      log("UnarchiveCard Variables $variables");
      final result = await GraphQLService.callGraphQL(
        query: mutation,
        variables: variables,
        isMutation: true,
      );

      if (result.hasException || result.data == null) {
        emit(currentState);
        HelperFunction.showAppSnackBar(message: "Failed to unarchive card");
      }
    } catch (e) {
      emit(currentState);
      HelperFunction.showAppSnackBar(message: "Failed to unarchive card");
    }
  }

  Future<void> refresh(String slug) async {
    _isLoadingMore = false;
    await fetchArchivedCards(slug, page: 1);
  }
}