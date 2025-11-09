import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:otper_mobile/app_graphql/graph_service.dart';
import 'package:otper_mobile/utils/helper/helper_function.dart';

const String loadLabelQuery = r'''
      query BoardBySlug($slug: String!) {
        boardBySlug(slug: $slug) {
          id
          labels {
            id
            name
            color
          }
        }
      }
    ''';

const String createLabelMutation = r'''
  mutation CreateLabel($boardId: ID!, $name: String!, $description: String!, $color: String!) {
    createLabel(
      input: { 
        board: { connect: $boardId }, 
        name: $name, 
        description: $description, 
        color: $color 
      }
    ) {
      id
      name
      description
      color
    }
  }
''';

const String updateLabelMutation = r'''
mutation UpdateLabel(
  $id: ID!,
  $name: String,
  $description: String,
  $color: String,
  $boardId: ID
) {
  updateLabel(
    input: {
      id: $id
      name: $name
      description: $description
      color: $color
      board: { connect: $boardId }
    }
  ) {
    id
    name
    description
    color
  }
}
''';

const String deleteLabelMutation = r'''
mutation DeleteLabel($id: ID!) {
  deleteLabel(id: $id) {
    id
  }
}
''';

class LabelState {
  final List<Label> labels;
  final bool isLoading;

  LabelState({
    this.labels = const [],
    this.isLoading = false,
  });

  LabelState copyWith({
    List<Label>? labels,
    bool? isLoading,
  }) {
    return LabelState(
      labels: labels ?? this.labels,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}


// Cubit
class LabelCubit extends Cubit<LabelState> {
  LabelCubit() : super( LabelState());

  Future<void> loadLabels(String slug) async {
    
    emit(state.copyWith(isLoading: true));  
    final result = await GraphQLService.callGraphQL(
      query: loadLabelQuery,
      variables: {"slug": slug},
    );

    if (!result.hasException && result.data != null) {
      final labelsJson = result.data!['boardBySlug']['labels'] as List;
      final labels = labelsJson.map((e) => Label.fromJson(e)).toList();
      emit(state.copyWith(labels: labels,isLoading: false));
    } else {
      debugPrint("Error loading labels: ${result.exception}");
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> createLabel({
    required String boardId,
    required String name,
    String? description,
    required Color color,x
  }) async {
    debugPrint("Create Label called");
    Map<String, dynamic> data = {
        "boardId": boardId,
        "name": name,
        "description": description ?? name,
        "color": HelperFunction.colorToHex(color),
      };
      debugPrint("Create Label data: $data");
    final result = await GraphQLService.callGraphQL(
      query: createLabelMutation,
      variables: data,
      isMutation: true,
    );

    if (!result.hasException && result.data != null) {
      final data = result.data!['createLabel'];
      final newLabel = Label.fromJson(data);
      final updated = [...state.labels, newLabel];
      emit(state.copyWith(labels: updated));
    } else {
        final errorMessage = result.exception?.graphqlErrors.isNotEmpty == true
        ? result.exception!.graphqlErrors.first.message
        : "Error creating label";

        if (errorMessage.contains("Internal server error")) {
          HelperFunction.showAppSnackBar(
            message: "Label already exists",
            backgroundColor: Colors.red,
          );
        } else {
          HelperFunction.showAppSnackBar(
            message: errorMessage,
            backgroundColor: Colors.red,
          );
      }
    }
  }
  Future<void> editLabel({
    required String id,
    String? boardId,
    String? name,
    String? description,
    Color? color,
  }) async {
    debugPrint("Edit Label called");
    Map<String, dynamic> data = {
      "id": id,
      "boardId": boardId,
      "name": name,
      "description": description ?? name,
      "color": color != null ? HelperFunction.colorToHex(color) : color,
    };
    debugPrint("Edit Label data: $data");

    final result = await GraphQLService.callGraphQL(
      query: updateLabelMutation,
      variables: data,
      isMutation: true,
    );

    if (!result.hasException && result.data != null) {
      final updatedLabel = Label.fromJson(result.data!['updateLabel']);
      final updatedLabels = state.labels.map((label) {
        return label.id == updatedLabel.id ? updatedLabel : label;
      }).toList();

      emit(state.copyWith(labels: updatedLabels));
    } else {
      final errorMessage = result.exception?.graphqlErrors.isNotEmpty == true
          ? result.exception!.graphqlErrors.first.message
          : "Error updating label";

      HelperFunction.showAppSnackBar(
        message: errorMessage,
        backgroundColor: Colors.red,
      );
    }
  }

  // void deleteLabel(int index) {
  //   final updated = List<Label>.from(state.labels)..removeAt(index);
  //   emit(state.copyWith(labels: updated));
  // }

  Future<void> deleteLabel(String id) async {
    debugPrint("Delete Label called: $id");

    final result = await GraphQLService.callGraphQL(
      query: deleteLabelMutation,
      variables: {"id": id},
      isMutation: true,
    );

    if (!result.hasException && result.data != null) {
      final deletedId = result.data!['deleteLabel']['id'];

      final updatedLabels =
          state.labels.where((label) => label.id != deletedId).toList();

      emit(state.copyWith(labels: updatedLabels));

      HelperFunction.showAppSnackBar(
        message: "Label deleted successfully",
        backgroundColor: Colors.green,
      );
    } else {
      final errorMessage = result.exception?.graphqlErrors.isNotEmpty == true
          ? result.exception!.graphqlErrors.first.message
          : "Error deleting label";

      HelperFunction.showAppSnackBar(
        message: errorMessage,
        backgroundColor: Colors.red,
      );
    }
  }
}

class Label {
  final String? id;
  final String name;
  final Color color;

  Label({
    this.id,
    required this.name,
    required this.color,
  });

  factory Label.fromJson(Map<String, dynamic> json) {
    return Label(
      id: json['id'],
      name: json['name'],
      color: HelperFunction.parseColor(json['color']), // backend usually stores HEX
    );
  }

  Label copyWith({String? id, String? name, Color? color}) {
    return Label(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }
}
