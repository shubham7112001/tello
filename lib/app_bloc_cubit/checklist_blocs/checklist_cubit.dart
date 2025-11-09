import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_graphql/graph_service.dart';
import 'package:otper_mobile/data/models/card_model.dart';
import 'checklist_state.dart';

class ChecklistCubit extends Cubit<ChecklistState> {
  ChecklistCubit({CardModel? card})
      : super(
          ChecklistState(
            cardId: card?.id ?? "",
            checklists: card?.checklist ?? [],
            addChecklistFocusNode: FocusNode(),
            itemFocusNodes: List.generate(
              card?.checklist?.length ?? 0,
              (_) => FocusNode(),
            ),
          ),
        );
  void toggleMainExpand() =>
      emit(state.copyWith(isExpanded: !state.isExpanded));

  void setMainExpand(bool expand) => emit(state.copyWith(isExpanded: expand));

  void toggleChecklistExpand(int index) {
    final isNowExpanded =
        state.focusedChecklistIndex == index ? null : index;

    emit(state.copyWith(
      focusedChecklistIndex: isNowExpanded,
      focusAddChecklist: false,
    ));
  }


  void addChecklist(String title, int pos) async {
    // 1. Create a temporary checklist for instant UI feedback
    final tempChecklist = CardChecklist(
      id: "temp-${DateTime.now().microsecondsSinceEpoch}", // temporary
      title: title,
      pos: pos,
      checkpoints: [],
    );

    final updatedChecklists = [...state.checklists, tempChecklist];

    updatedChecklists.sort((a, b) => (a.pos ?? 0).compareTo(b.pos ?? 0));

    final updatedItemFocusNodes = [...state.itemFocusNodes, FocusNode()];

    emit(state.copyWith(
      checklists: updatedChecklists,
      itemFocusNodes: updatedItemFocusNodes,
      focusAddChecklist: false,
    ));

    // Focus last after UI rebuild
    Future.delayed(const Duration(milliseconds: 100), () {
      updatedItemFocusNodes.last.requestFocus();
    });

    // 2. Call GraphQL API
    final String mutation = '''
      mutation CreateChecklist(\$cardId: ID!, \$title: String!) {
        createChecklist(input: { card: { connect: \$cardId }, title: \$title }) {
          id
          title
        }
      }
    ''';

    final variables = {
      "cardId": state.cardId, // make sure you store current card id in state
      "title": title,
    };

    final result = await GraphQLService.callGraphQL(
      query: mutation,
      variables: variables,
      isMutation: true,
    );

    // 3. Handle API response
    if (result.hasException) {
      debugPrint("Checklist creation failed: ${result.exception.toString()}");

      // rollback the temp checklist
      final rolledBack = [...state.checklists]..removeWhere((c) => c.id == tempChecklist.id);
      emit(state.copyWith(checklists: rolledBack));
    } else {
      final data = result.data?['createChecklist'];
      if (data != null) {
        final serverChecklist = CardChecklist(
          id: data['id'].toString(),
          title: data['title'],
          pos: pos,
          checkpoints: [],
        );

        // replace temp with server one
        final replaced = [...state.checklists]
          ..removeWhere((c) => c.id == tempChecklist.id)
          ..add(serverChecklist);

        replaced.sort((a, b) => (a.pos ?? 0).compareTo(b.pos ?? 0));

        emit(state.copyWith(checklists: replaced));
      }
    }
  }


  void addChecklistItem(int checklistIndex, String title, int pos) async {
    final updatedChecklists = [...state.checklists];
    final targetChecklist = updatedChecklists[checklistIndex];

    // 1. Create a temporary checkpoint for instant UI feedback
    final tempCheckpoint = CardCheckPoint(
      id: "temp-${DateTime.now().microsecondsSinceEpoch}", // temporary id
      title: title,
      status: false,
      pos: pos,
    );

    final updatedItems = [...?targetChecklist.checkpoints, tempCheckpoint];

    updatedChecklists[checklistIndex] = CardChecklist(
      id: targetChecklist.id,
      pos: targetChecklist.pos,
      title: targetChecklist.title,
      checkpoints: updatedItems,
    );

    emit(state.copyWith(checklists: updatedChecklists));

    Future.delayed(Duration.zero, () {
      state.itemFocusNodes[checklistIndex].requestFocus();
    });

    // 2. Call GraphQL API
    final String mutation = '''
      mutation CreateCheckpoint(\$title: String!, \$checklistId: ID!) {
        createCheckpoint(input: { title: \$title, checklist: { connect: \$checklistId } }) {
          id
          title
          status
          pos
        }
      }
    ''';

    final variables = {
      "title": title,
      "checklistId": targetChecklist.id,
    };

    final result = await GraphQLService.callGraphQL(
      query: mutation,
      variables: variables,
      isMutation: true,
    );

    // 3. Handle API response
    if (result.hasException) {
      debugPrint("Create checkpoint failed: ${result.exception}");

      // rollback on failure
      final rollbackItems = [...?targetChecklist.checkpoints]
        ..removeWhere((c) => c.id == tempCheckpoint.id);

      final rollbackChecklists = [...state.checklists];
      rollbackChecklists[checklistIndex] = CardChecklist(
        id: targetChecklist.id,
        pos: targetChecklist.pos,
        title: targetChecklist.title,
        checkpoints: rollbackItems,
      );

      emit(state.copyWith(checklists: rollbackChecklists));
    } else {
      final data = result.data?['createCheckpoint'];
      if (data != null) {
        final serverCheckpoint = CardCheckPoint(
          id: data['id'].toString(),
          title: data['title'],
          status: data['status'],
          pos: data['pos'] ?? pos,
        );

        final syncedItems = [...?targetChecklist.checkpoints]
          ..removeWhere((c) => c.id == tempCheckpoint.id)
          ..add(serverCheckpoint);

        final syncedChecklists = [...state.checklists];
        syncedChecklists[checklistIndex] = CardChecklist(
          id: targetChecklist.id,
          pos: targetChecklist.pos,
          title: targetChecklist.title,
          checkpoints: syncedItems,
        );

        emit(state.copyWith(checklists: syncedChecklists));
      }
    }
  }

  void toggleChecklistItemStatus(int checklistIndex, int itemIndex) async {
    final updatedChecklists = [...state.checklists];
    final targetChecklist = updatedChecklists[checklistIndex];
    final updatedItems = [...?targetChecklist.checkpoints];

    final checkpoint = updatedItems[itemIndex];
    final newStatus = !(checkpoint.status ?? false);

    updatedItems[itemIndex] = CardCheckPoint(
      id: checkpoint.id,
      title: checkpoint.title,
      status: newStatus,
      pos: checkpoint.pos,
    );

    updatedChecklists[checklistIndex] = CardChecklist(
      id: targetChecklist.id,
      pos: targetChecklist.pos,
      title: targetChecklist.title,
      checkpoints: updatedItems,
    );

    emit(state.copyWith(checklists: updatedChecklists));

    // 2. Call GraphQL API
    final String mutation = '''
      mutation UpdateCheckpoint(\$id: ID!, \$title: String, \$status: Boolean, \$checklistId: ID) {
        updateCheckpoint(
          input: { id: \$id, title: \$title, status: \$status, checklist: { connect: \$checklistId } }
        ) {
          id
          title
          status
        }
      }
    ''';

    final variables = {
      "id": checkpoint.id,
      "title": checkpoint.title,
      "status": newStatus,
      "checklistId": targetChecklist.id,
    };

    debugPrint("Updating checkpoint with variables: $variables");
    final result = await GraphQLService.callGraphQL(
      query: mutation,
      variables: variables,
      isMutation: true,
    );

    // 3. Handle API result
    if (result.hasException) {
      debugPrint("Update checkpoint failed: ${result.exception}");

      // rollback on failure
      final rollbackItems = [...?targetChecklist.checkpoints];
      rollbackItems[itemIndex] = checkpoint; // old value

      final rollbackChecklists = [...state.checklists];
      rollbackChecklists[checklistIndex] = CardChecklist(
        id: targetChecklist.id,
        pos: targetChecklist.pos,
        title: targetChecklist.title,
        checkpoints: rollbackItems,
      );

      emit(state.copyWith(checklists: rollbackChecklists));
    } else {
      final data = result.data?['updateCheckpoint'];
      if (data != null) {
        final serverCheckpoint = CardCheckPoint(
          id: data['id'].toString(),
          title: data['title'] ?? checkpoint.title,
          status: data['status'] ?? newStatus,
          pos: checkpoint.pos,
        );

        final syncedItems = [...?targetChecklist.checkpoints];
        syncedItems[itemIndex] = serverCheckpoint;

        final syncedChecklists = [...state.checklists];
        syncedChecklists[checklistIndex] = CardChecklist(
          id: targetChecklist.id,
          pos: targetChecklist.pos,
          title: targetChecklist.title,
          checkpoints: syncedItems,
        );

        emit(state.copyWith(checklists: syncedChecklists));
      }
    }
  }


  void sortChecklistsByPos() {
    final sorted = [...state.checklists];
    sorted.sort((a, b) => (a.pos ?? 0).compareTo(b.pos ?? 0));

    emit(state.copyWith(checklists: sorted));
  }

  void sortChecklistItemsByPos(int checklistIndex) {
    final updated = [...state.checklists];
    final checklist = updated[checklistIndex];

    final sortedItems = [...?checklist.checkpoints];
    sortedItems.sort((a, b) => (a.pos ?? 0).compareTo(b.pos ?? 0));

    updated[checklistIndex] = CardChecklist(
      id: checklist.id,
      pos: checklist.pos,
      checkpoints: sortedItems,
    );

    emit(state.copyWith(checklists: updated));
  }


}
