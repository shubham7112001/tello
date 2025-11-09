import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:otper_mobile/app_graphql/graph_service.dart';
import 'package:otper_mobile/utils/helper/helper_function.dart';

class ListItem {
  final String? id;
  final String? name;
  final Color? color;
  final String? pos;

  ListItem({
    this.id,
    this.name,
    this.color,
    this.pos,
  });

  factory ListItem.fromJson(Map<String, dynamic> json) {
    return ListItem(
      id: json["id"],
      name: json["name"],
      pos: json["pos"],
      color: HelperFunction.parseColor(json["color"] as String),
    );
  }
    ListItem copyWith({
    String? id,
    String? name,
    Color? color,
    String? pos,
  }) {
    return ListItem(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      pos: pos ?? this.pos,
    );
  }
}


class ListState extends Equatable {
  final List<ListItem> lists;
  final bool isLoading;

  const ListState({this.lists = const [], this.isLoading = false});

  ListState copyWith({List<ListItem>? lists, bool? isLoading}) {
    return ListState(
      lists: lists ?? this.lists,
      isLoading: isLoading ?? this.isLoading
      );
  }

  @override
  List<Object?> get props => [lists];
}

class ListCubit extends Cubit<ListState> {
  ListCubit() : super(const ListState());

  Future<void> loadLists(String slug) async {
    emit(state.copyWith(isLoading: true));
    const query = r'''
      query BoardBySlug($slug: String!) {
        boardBySlug(slug: $slug) {
          lists {
            id
            color
            name
            pos
          }
        }
      }
    ''';

    final result = await GraphQLService.callGraphQL(
      query: query,
      variables: {"slug": slug},
    );

    if (!result.hasException && result.data != null) {
      final lists = result.data!["boardBySlug"]["lists"] as List;
      final parsedLists = lists
          .map((e) => ListItem.fromJson(e))
          .toList()
          ..sort((a, b) {
            if (a.pos == null && b.pos == null) return 0;  
            if (a.pos == null) return 1;                     
            if (b.pos == null) return -1;                    
            return a.pos!.compareTo(b.pos!);             
          });
      emit(state.copyWith(lists: parsedLists, isLoading: false));
    } else {
      debugPrint("Error loading lists: ${result.exception}");
      emit(state.copyWith(isLoading: false));
    }
  }

  // void addList(String name, Color color) {
  //   final updated = [...state.lists, ListItem(name: name, color: color)];
  //   emit(state.copyWith(lists: updated));
  // }

  // void editList(int index, String newName, Color newColor) {
  //   final updated = [...state.lists];
  //   updated[index] = ListItem(name: newName, color: newColor);
  //   emit(state.copyWith(lists: updated));
  // }

  // void deleteList(int index) {
  //   final updated = [...state.lists]..removeAt(index);
  //   emit(state.copyWith(lists: updated));
  // }

  // void reorderList(int oldIndex, int newIndex) {
  //   final updated = [...state.lists];

  //   if (newIndex > oldIndex) {
  //     newIndex -= 1;
  //   }

  //   final item = updated.removeAt(oldIndex);
  //   updated.insert(newIndex, item);

  //   emit(state.copyWith(lists: updated));
  // }

  Future<void> createList({
    required String boardId,
    required String name,
    required Color color,
    String? description,
    int? pos,
    bool preferred = false,
  }) async {
    try {
      // 🔹 Step 1: Optimistic local update
      final tempList = ListItem(name: name, color: color);
      final optimistic = [...state.lists, tempList];
      emit(state.copyWith(lists: optimistic));

      // 🔹 Step 2: GraphQL Mutation
      const String mutation = r'''
        mutation CreateLists($boardId: ID!, $name: String!, $description: String!, $color: String, $pos: String, $preferred: Boolean!) {
          createLists(
            input: {
              board: { connect: $boardId }
              name: $name
              description: $description
              color: $color
              pos: $pos
              preferred: $preferred
            }
          ) {
            id
            name
            description
            color
            pos
            preferred
          }
        }
      ''';

      final variables = {
        "boardId": boardId,
        "name": name,
        "description": description ?? name,
        "color": color.value.toRadixString(16),
        "pos": pos,
        "preferred": preferred,
      };

      final result = await GraphQLService.callGraphQL(
        query: mutation,
        variables: variables,
        isMutation: true,
      );

      // 🔹 Step 3: Handle response
      if (!result.hasException && result.data != null) {
        final data = result.data!["createLists"];

        final newList = ListItem(
          name: data["name"] ?? name,
          color: Color(int.parse(data["color"] ?? color.value.toRadixString(16), radix: 16)),
        );

        // Replace optimistic temp with actual response
        final updated = [...state.lists]..remove(tempList)..add(newList);
        emit(state.copyWith(lists: updated));
      } else {
        debugPrint("Error creating list: ${result.exception}");
        // Rollback optimistic update if failed
        final rolledBack = [...state.lists]..remove(tempList);
        emit(state.copyWith(lists: rolledBack));
      }
    } catch (e) {
      debugPrint("Exception in addList: $e");
      // Rollback on crash
      final rolledBack = [...state.lists]..removeWhere((l) => l.name == name && l.color == color);
      emit(state.copyWith(lists: rolledBack));
    }
  }

  Future<void> editList({
    required String id,
    required String newName,
    required Color newColor,
    String? description,
    String? pos,
    bool? preferred,
    required String boardId,
  }) async {
    try {
      // 🔹 Step 1: Get target list by id
      final target = state.lists.firstWhere((l) => l.id == id);

      // 🔹 Step 2: Optimistic update
      final optimistic = state.lists.map((l) {
        if (l.id == id) {
          return l.copyWith(
            name: newName,
            color: newColor,
            pos: pos ?? l.pos ,
          );
        }
        return l;
      }).toList();

      emit(state.copyWith(lists: optimistic));

      // 🔹 Step 3: GraphQL Mutation
      const String mutation = r'''
        mutation UpdateLists(
          $id: ID!, 
          $name: String, 
          $color: String, 
          $boardId: ID!
        ) {
          updateLists(
            input: {
              id: $id
              name: $name
              color: $color
              board: { connect: $boardId }
            }
          ) {
            id
            name
            color
          }
        }
      ''';

      final variables = {
        "id": id,
        "name": newName,
        "color": newColor.value.toRadixString(16), 
        "boardId": boardId,
      };

      final result = await GraphQLService.callGraphQL(
        query: mutation,
        variables: variables,
        isMutation: true,
      );

      // 🔹 Step 4: Handle response
      if (!result.hasException && result.data != null) {
        final data = result.data!["updateLists"];

        final updatedList = target.copyWith(
          name: data["name"] ?? newName,
          color: Color(int.parse(data["color"], radix: 16)),
          pos: data["pos"] ?? pos,
        );

        final confirmed = state.lists.map((l) {
          return l.id == id ? updatedList : l;
        }).toList();

        emit(state.copyWith(lists: confirmed));
      } else {
        debugPrint("Error updating list: ${result.exception}");
        // rollback
        emit(state.copyWith(lists: state.lists));
      }
    } catch (e) {
      debugPrint("Exception in editList: $e");
      // rollback
      emit(state.copyWith(lists: state.lists));
    }
  }

  Future<void> deleteList(String id) async {
    final target = state.lists.firstWhere((l) => l.id == id);
    try {
      final optimistic = [...state.lists]..removeWhere((l) => l.id == id);
      emit(state.copyWith(lists: optimistic));

      const String mutation = r'''
        mutation DeleteLists($id: ID!) {
          deleteLists(id: $id) {
            id
          }
        }
      ''';

      final variables = {"id": id};

      final result = await GraphQLService.callGraphQL(
        query: mutation,
        variables: variables,
        isMutation: true,
      );

      if (!result.hasException && result.data != null) {
        final deletedId = result.data!["deleteLists"]["id"];
        debugPrint("List deleted successfully: $deletedId");
      } else {
        debugPrint("Error deleting list: ${result.exception}");
        final rolledBack = [...state.lists, target];
        emit(state.copyWith(lists: rolledBack));
      }
    } catch (e) {
      debugPrint("Exception in deleteList: $e");
      final rolledBack = [...state.lists];
      if (!rolledBack.contains(target)) rolledBack.add(target);
      emit(state.copyWith(lists: rolledBack));
    }
  }

  Future<void> reorderList(int oldIndex, int newIndex) async {
  final updated = [...state.lists];

  if (newIndex > oldIndex) {
    newIndex -= 1;
  }

 final movingItem = updated.removeAt(oldIndex);
  updated.insert(newIndex, movingItem);

  // 🔹 Optimistic UI update
  emit(state.copyWith(lists: updated));

  final String activeListId = movingItem.id!;
  String toListId;

  // If moved to last → use last item’s id
  if (newIndex + 1 < updated.length) {
    toListId = updated[newIndex + 1].id!;
  } else {
    toListId = updated.last.id!;
  }


  try {
    // 🔹 Step 3: GraphQL mutation
    const String mutation = r'''
      mutation ReorderLists($activeListId: ID!, $toListId: ID!) {
        reorderLists(input: { activelistId: $activeListId, toListId: $toListId }) {
          success
          message
        }
      }
    ''';

    final variables = {
      "activeListId": activeListId,
      "toListId": toListId,
    };

    final result = await GraphQLService.callGraphQL(
      query: mutation,
      variables: variables,
      isMutation: true,
    );

    // 🔹 Step 4: Handle response
    if (!result.hasException && result.data != null) {
      final success = result.data!["reorderLists"]["success"];
      if (success != true) {
        debugPrint("Reorder mutation returned failure");
        HelperFunction.showAppSnackBar(message: result.data!["reorderLists"]["message"] ?? "Error reordering lists", backgroundColor: Colors.red);
        emit(state.copyWith(lists: state.lists));
      }
    } else {
      debugPrint("Error reordering lists: ${result.exception}");
      HelperFunction.showAppSnackBar(message: "Error reordering lists", backgroundColor: Colors.red);
      // rollback
      emit(state.copyWith(lists: state.lists));
    }
  } catch (e) {
    debugPrint("Exception in reorderList: $e");
    HelperFunction.showAppSnackBar(message: "Error while reordering", backgroundColor: Colors.red);
    // rollback
    emit(state.copyWith(lists: state.lists));
  }
}

}
