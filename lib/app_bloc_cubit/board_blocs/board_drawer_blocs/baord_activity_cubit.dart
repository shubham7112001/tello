import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_bloc_cubit/board_blocs/board_drawer_blocs/board_comment_cubit.dart';
import 'package:otper_mobile/app_graphql/graph_service.dart';

class BoardAction {
  final String id;
  final String type;
  final String action;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ActionOwner? owner;
  final ActionCard? card;
  final ActionUser? creator;

  BoardAction({
    required this.id,
    required this.type,
    required this.action,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
    this.owner,
    this.card,
    this.creator,
  });

  factory BoardAction.fromJson(Map<String, dynamic> json) {
    return BoardAction(
      id: json['id'].toString(),
      type: json['type'] ?? '',
      action: json['action'] ?? '',
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      owner: json['owner'] != null ? ActionOwner.fromJson(json['owner']) : null,
      card: json['card'] != null ? ActionCard.fromJson(json['card']) : null,
      creator:
          json['creator'] != null ? ActionUser.fromJson(json['creator']) : null,
    );
  }
}

class ActionOwner {
  final String id;
  final String? slug;
  final String? title;
  final String? name;
  final String? comment;

  ActionOwner({
    required this.id,
    this.slug,
    this.title,
    this.name,
    this.comment,
  });

  factory ActionOwner.fromJson(Map<String, dynamic> json) {
    return ActionOwner(
      id: json['id'].toString(),
      slug: json['slug'],
      title: json['title'],
      name: json['name'],
      comment: json['comment'],
    );
  }
}

class ActionCard {
  final String id;
  final String slug;
  final String title;

  ActionCard({
    required this.id,
    required this.slug,
    required this.title,
  });

  factory ActionCard.fromJson(Map<String, dynamic> json) {
    return ActionCard(
      id: json['id'].toString(),
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
    );
  }
}

class ActionUser {
  final String id;
  final String name;
  final String? email;
  final String? username;

  ActionUser({
    required this.id,
    required this.name,
    this.email,
    this.username,
  });

  factory ActionUser.fromJson(Map<String, dynamic> json) {
    return ActionUser(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'],
      username: json['username'],
    );
  }
}


// Events

abstract class ActionEvent {}

class LoadBoardActions extends ActionEvent {
  final String slug;
  final int page;
  final bool loadMore; // ✅ differentiate initial vs loadMore

  LoadBoardActions({
    required this.slug,
    this.page = 1,
    this.loadMore = false,
  });
}



// States
abstract class ActionState {}

class ActionInitial extends ActionState {}

class ActionLoading extends ActionState {}

class ActionLoaded extends ActionState {
  final List<BoardAction> actions;
  final PaginatorInfo paginator;

  ActionLoaded({
    required this.actions,
    required this.paginator,
  });

  ActionLoaded copyWith({
    List<BoardAction>? actions,
    PaginatorInfo? paginator,
  }) {
    return ActionLoaded(
      actions: actions ?? this.actions,
      paginator: paginator ?? this.paginator,
    );
  }
}

class ActionError extends ActionState {
  final String message;
  ActionError(this.message);
}

// Bloc

class ActionBloc extends Bloc<ActionEvent, ActionState> {
  ActionBloc() : super(ActionInitial()) {
    on<LoadBoardActions>(_onLoadBoardActions);
  }

  Future<void> _onLoadBoardActions(
      LoadBoardActions event, Emitter<ActionState> emit) async {
    // Show loader only for first page
    if (!event.loadMore) {
      emit(ActionLoading());
    }

    const String query = r'''
      query BoardBySlug($slug: String!, $page: Int!) {
        boardBySlug(slug: $slug) {
          chronologicalActions(first: 10, page: $page) {
            paginatorInfo {
              count
              currentPage
              firstItem
              hasMorePages
              lastItem
              lastPage
              perPage
              total
            }
            data {
              id
              type
              action
              metadata
              created_at
              updated_at
              owner {
                ... on Comment { id comment created_at }
                ... on Card { id slug title }
                ... on Board { id slug name }
                ... on User { id name username email }
              }
              card { id slug title }
              creator { id name email username }
            }
          }
        }
      }
    ''';

    try {
      final result = await GraphQLService.callGraphQL(
        query: query,
        variables: {"slug": event.slug, "page": event.page},
      );

      if (result.hasException) {
        emit(ActionError(result.exception.toString()));
        return;
      }

      final actionData =
          result.data?['boardBySlug']?['chronologicalActions'] ?? {};
      final List<dynamic> rawActions = actionData['data'] ?? [];
      final List<BoardAction> fetched =
          rawActions.map((e) => BoardAction.fromJson(e)).toList();

      final paginator = PaginatorInfo.fromJson(actionData['paginatorInfo']);

      if (event.loadMore && state is ActionLoaded) {
        final current = (state as ActionLoaded);
        emit(current.copyWith(
          actions: [...current.actions, ...fetched],
          paginator: paginator,
        ));
      } else {
        emit(ActionLoaded(actions: fetched, paginator: paginator));
      }
    } catch (e) {
      emit(ActionError(e.toString()));
    }
  }
}
