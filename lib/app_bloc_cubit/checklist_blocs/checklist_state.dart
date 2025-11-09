import 'package:flutter/material.dart';
import 'package:otper_mobile/data/models/card_model.dart'; // <-- your CardChecklist model

class ChecklistState {
  final bool isExpanded;
  final List<CardChecklist> checklists;
  final bool isAdding;
  final int? focusedChecklistIndex;
  final bool focusAddChecklist;

  final FocusNode addChecklistFocusNode;
  final List<FocusNode> itemFocusNodes;
  final String cardId;

  ChecklistState({
    this.isExpanded = false,
    this.checklists = const [],
    this.isAdding = false,
    this.focusedChecklistIndex,
    this.focusAddChecklist = false,
    required this.addChecklistFocusNode,
    required this.itemFocusNodes,
    required this.cardId,
  });

  ChecklistState copyWith({
    bool? isExpanded,
    List<CardChecklist>? checklists,
    bool? isAdding,
    int? focusedChecklistIndex,
    bool? focusAddChecklist,
    FocusNode? addChecklistFocusNode,
    List<FocusNode>? itemFocusNodes,
    String? cardId,
  }) {
    return ChecklistState(
      isExpanded: isExpanded ?? this.isExpanded,
      checklists: checklists ?? this.checklists,
      isAdding: isAdding ?? this.isAdding,
      focusedChecklistIndex: focusedChecklistIndex ?? this.focusedChecklistIndex,
      focusAddChecklist: focusAddChecklist ?? this.focusAddChecklist,
      addChecklistFocusNode: addChecklistFocusNode ?? this.addChecklistFocusNode,
      itemFocusNodes: itemFocusNodes ?? this.itemFocusNodes,
      cardId: cardId ?? this.cardId,
    );
  }
}
