import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_graphql/graph_service.dart';
import 'package:otper_mobile/utils/helper/helper_function.dart';

class CardCommentCubit extends Cubit<String> {
  CardCommentCubit() : super("");

  void updateComment(String value) => emit(value);
  void clearComment() => emit("");

  void addComment(String cardId, String boardId, String commentText) async {

    // 2. Call GraphQL API
    final String mutation = '''
      mutation CreateComment(\$comment: String!, \$cardId: ID!, \$boardId: ID!) {
        createComment(
          input: { 
            comment: \$comment, 
            card: { connect: \$cardId }, 
            board: { connect: \$boardId } 
          }
        ) {
          id
          comment
        }
      }
    ''';

    final variables = {
      "comment": commentText,
      "cardId": cardId,
      "boardId": boardId,
    };

    final result = await GraphQLService.callGraphQL(
      query: mutation,
      variables: variables,
      isMutation: true,
    );

    // 3. Handle API response
    if (result.hasException) {
      HelperFunction.showAppSnackBar(message: "Failed to add comment",backgroundColor: Colors.red);
      debugPrint("Create comment failed: ${result.exception}");
    } else {
      HelperFunction.showAppSnackBar(message: "Comment added successfully", backgroundColor: Colors.green);
      clearComment();
    }
  }
}