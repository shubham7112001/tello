import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:otper_mobile/app_graphql/graph_document.dart';
import 'package:otper_mobile/app_graphql/graph_service.dart';
import 'package:otper_mobile/data/db/action_db/api_queue_helper.dart';
import 'package:otper_mobile/data/models/board_model.dart';
import 'package:otper_mobile/data/models/home_board_model.dart';

import '../../app_flowy_board/appflowy_board.dart';

part 'board_event.dart';
part 'board_state.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  BoardBloc() : super(BoardInitial()) {
    on<LoadBoardEvent>(_onLoadBoard);
    on<MoveGroupItemEvent>(_onMoveGroupItem);
    on<MoveGroupEvent>(_onMoveGroup);
    on<MoveGroupItemToGroupEvent>(_onMoveGroupItemToGroup);
    on<AddCardEvent>(_onAddCard);
  }

  void _onLoadBoard(LoadBoardEvent event, Emitter<BoardState> emit) async{
    final HomeBoardModel homeBoardModel = event.board;
    emit(BoardLoading());
    debugPrint(homeBoardModel.toString());
    if(homeBoardModel.slug == null) return;

    final QueryResult result = await GraphQLService.callGraphQL(
      query: GraphDocument.boardBySlug(homeBoardModel.slug ?? ''),
    );

    if (result.hasException) {
      debugPrint("GraphQL Exception: ${result.exception.toString()}");
      emit(BoardError(message: "Failed to load board data"));
      return;
    }

    final data = result.data?['boardBySlug'];
    if (data == null) {
      debugPrint("No board data found");
      emit(BoardError(message: "No data found for this board"));
      return;
    }

    final boardModel = BoardModel.fromJson(data);
    debugPrint("BoardModel: $boardModel");

    final controller = AppFlowyBoardController(
      onMoveGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
        debugPrint('Move group from $fromIndex to $toIndex');

        add(MoveGroupEvent(fromIndex: fromIndex, toIndex: toIndex));
        
      },
      onMoveGroupItem: (groupId, fromIndex, toIndex) {
        debugPrint('Move $groupId:$fromIndex to $groupId:$toIndex');

        add(MoveGroupItemEvent(
          groupId: groupId,
          fromIndex: fromIndex,
          toIndex: toIndex,
        ));

      },
      onMoveGroupItemToGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
        debugPrint('Move $fromGroupId:$fromIndex to $toGroupId:$toIndex');
        add(MoveGroupItemToGroupEvent(
          fromGroupId: fromGroupId,
          fromIndex: fromIndex,
          toGroupId: toGroupId,
          toIndex: toIndex,
        ));
      },
    );

    final groups = boardModel.lists.map((list) {
      final group = AppFlowyGroupData(
        id: list.id,
        name: list.name,
        items: list.cards.map<AppFlowyGroupItem>((c) => CardItem(c)).toList(),
      );
      controller.addGroup(group); 
      return group;
    }).toList();

    emit(BoardLoaded(controller: controller, groups: groups));
  }

  void _onMoveGroupItem(MoveGroupItemEvent event, Emitter<BoardState> emit) async {
    debugPrint("Current state on _onMoveGroupItem is $state");
    if (state is BoardLoaded) {
      final currentState = state as BoardLoaded;
      final group = currentState.groups.firstWhere((g) => g.id == event.groupId);
      final cardItem = group.items[event.fromIndex] as CardItem;

      int? overCardId;
      if (event.toIndex < group.items.length) {
        overCardId = int.parse((group.items[event.toIndex] as CardItem).id);
      }

      try {
        await ApiQueueHelper().moveTo(
          cardId: int.parse(cardItem.id),
          toListId: int.parse(event.groupId),
          overCardId: overCardId,
        );
        debugPrint("Backend synced successfully!");
      } catch (e) {
        debugPrint("Backend sync failed: $e");
      }
    }
  }

  void _onMoveGroupItemToGroup(MoveGroupItemToGroupEvent event, Emitter<BoardState> emit) async {
    debugPrint("Current state on _onMoveGroupItemToGroup is $state");

    if (state is! BoardLoaded) {
      debugPrint("State is not loaded, but still attempting backend call");
    }

    final currentState = state is BoardLoaded ? state as BoardLoaded : null;

    CardItem? cardItem;
    int toListId = int.parse(event.toGroupId);
    int? overCardId;

    if (currentState != null) {
      try {
        final fromGroup = currentState.groups.firstWhere(
          (g) => g.id == event.fromGroupId,
          orElse: () => throw Exception("From group not found"),
        );

        if (fromGroup.items.isNotEmpty && event.fromIndex < fromGroup.items.length) {
          cardItem = fromGroup.items[event.fromIndex] as CardItem;
        }

        final toGroup = currentState.groups.firstWhere(
          (g) => g.id == event.toGroupId,
          orElse: () => throw Exception("To group not found"),
        );

        if (toGroup.items.isNotEmpty && event.toIndex < toGroup.items.length) {
          overCardId = int.parse((toGroup.items[event.toIndex] as CardItem).id);
        }
      } catch (e) {
        debugPrint("Error preparing backend call: $e");
      }
    }

    try {
      final cardId = cardItem != null ? int.parse(cardItem.id) : overCardId;

      await ApiQueueHelper().moveTo(
        cardId: cardId!,
        toListId: toListId,
        overCardId: cardItem != null ? overCardId : null,
      );

      debugPrint("Backend synced successfully!");
    } catch (e) {
      debugPrint("Backend sync failed: $e");
    }
  }


  void _onMoveGroup(MoveGroupEvent event, Emitter<BoardState> emit) async {
    debugPrint("Current state on _onMoveGroup is $state");

    if (state is! BoardLoaded) return;
    final currentState = state as BoardLoaded;

    if (event.fromIndex < 0 || event.fromIndex >= currentState.groups.length) return;
    if (event.toIndex < 0 || event.toIndex >= currentState.groups.length) return;

    final updatedGroups = List.from(currentState.groups);
    final group = updatedGroups.removeAt(event.fromIndex);
    updatedGroups.insert(event.toIndex, group);

    try {
      final activeListId = int.tryParse(group.id);
      final toListId = int.tryParse(updatedGroups[event.toIndex].id);

      if (activeListId == null || toListId == null) {
        debugPrint("Error: group IDs cannot be null");
        return;
      }

      await ApiQueueHelper().reorderLists(
        activeListId: activeListId,
        toListId: toListId,
      );
      debugPrint("Backend list reorder synced successfully!");
    } catch (e, st) {
      debugPrint("Backend list reorder failed: $e");
      debugPrint(st.toString());
      emit(currentState);
    }
  }

  Future<void> _onAddCard(AddCardEvent event, Emitter<BoardState> emit) async {
      debugPrint("_onAddCard called with listId: ${event.listId}, title: ${event.title}");
      
      if (state is! BoardLoaded) {
        debugPrint("Board is not loaded, cannot add card");
        emit(BoardError(message: "Board is not loaded"));
        return;
      }

      final currentState = state as BoardLoaded;

      try {
        final result = await GraphQLService.callGraphQL(
          query: '''
            mutation CreateCard(\$listId: ID!, \$title: String!, \$description: String) {
              createCard(input: { list: { connect: \$listId }, title: \$title, description: \$description }) {
                id
                slug
                title
                pos
                card_number
                due_date
                users {
                  id
                  name
                }
                labels {
                  id
                  name
                  color
                }
              }
            }
          ''',
          variables: {
            "listId": event.listId,
            "title": event.title,
            "description": event.description,
          },
          isMutation: true,
        );

        if (result.hasException) {
          debugPrint("GraphQL Exception while adding card: ${result.exception}");
          emit(BoardError(message: "Failed to add card: ${result.exception}"));
          return;
        }

        final cardData = result.data?['createCard'];
        if (cardData == null) {
          debugPrint("No data returned from add card mutation");
          emit(BoardError(message: "Failed to create card"));
          return;
        }

        final newCard = BoardViewCardModel.fromJson(cardData);
        final cardItem = CardItem(newCard);

        // Update the controller first
        currentState.controller.addGroupItem(event.listId, cardItem);

        // Update the groups state
        final updatedGroups = currentState.groups.map((group) {
          if (group.id == event.listId) {
            final updatedItems = List<AppFlowyGroupItem>.from(group.items)..add(cardItem);
            return AppFlowyGroupData(
              id: group.id,
              name: group.headerData.groupName,
              items: updatedItems,
            );
          }
          return group;
        }).toList();

        emit(BoardLoaded(controller: currentState.controller, groups: updatedGroups));
        debugPrint("Card added successfully: ${newCard.title}");
      } catch (e, st) {
        debugPrint("Error while adding card: $e");
        debugPrint(st.toString());
        emit(BoardError(message: "Failed to add card: $e"));
      }
    }
  }
  



class CardItem extends AppFlowyGroupItem {
  final BoardViewCardModel card;
  CardItem(this.card);

  @override
  String get id => card.id.toString();
}
