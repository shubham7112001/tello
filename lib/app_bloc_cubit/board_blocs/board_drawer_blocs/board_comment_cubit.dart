import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_graphql/graph_service.dart';

import 'package:equatable/equatable.dart';

abstract class BoardCommentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BoardCommentInitial extends BoardCommentState {}

class BoardCommentLoading extends BoardCommentState {}

class BoardCommentLoaded extends BoardCommentState {
  final List<BoardCommentModel> comments;
  final PaginatorInfo paginatorInfo;
  final bool isLoadingMore;

  BoardCommentLoaded(this.comments, this.paginatorInfo, {this.isLoadingMore = false});

  BoardCommentLoaded copyWith({
    List<BoardCommentModel>? comments,
    PaginatorInfo? paginatorInfo,
    bool? isLoadingMore,
  }) {
    return BoardCommentLoaded(
      comments ?? this.comments,
      paginatorInfo ?? this.paginatorInfo,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [comments, paginatorInfo, isLoadingMore];
}

class BoardCommentError extends BoardCommentState {
  final String message;

  BoardCommentError(this.message);

  @override
  List<Object?> get props => [message];
}



class BoardCommentCubit extends Cubit<BoardCommentState> {
  BoardCommentCubit() : super(BoardCommentInitial());

  String? _slug;

  String query = r'''
      query BoardBySlug($slug: String!, $first: Int!, $page: Int!) {
        boardBySlug(slug: $slug) {
          chronologicalComments(first: $first, page: $page) {
            data {
              id
              comment
              edited_at
              created_at
              card {
                slug
                title
              }
              files {
                name
                size
              }
            }
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
          }
        }
      }
    ''';
  
  Future<void> fetchComments({String? slug,int first = 10, int page = 1}) async {
    _slug = slug;
    
    if (state is BoardCommentLoaded && page > 1) {
      final current = state as BoardCommentLoaded;
      emit(current.copyWith(isLoadingMore: true));
    } else {
      emit(BoardCommentLoading());
    }

    try {
      final result = await GraphQLService.callGraphQL(
        query: query,
        variables: {
          "slug": slug,
          "first": first,
          "page": page,
        },
      );

      if (result.hasException) {
        emit(BoardCommentError(result.exception.toString()));
        return;
      }

      final response = result.data?["boardBySlug"]?["chronologicalComments"];
      final data = response?["data"] ?? [];
      final paginatorJson = response?["paginatorInfo"];

      final comments = (data as List)
          .map((json) => BoardCommentModel.fromJson(json as Map<String, dynamic>))
          .toList();

      final paginatorInfo = PaginatorInfo.fromJson(paginatorJson);

      if (state is BoardCommentLoaded && page > 1) {
        // append new comments to old list
        final current = state as BoardCommentLoaded;
        final updatedComments = [...current.comments, ...comments];
        emit(BoardCommentLoaded(updatedComments, paginatorInfo));
      } else {
        emit(BoardCommentLoaded(comments, paginatorInfo));
      }
    } catch (e) {
      emit(BoardCommentError(e.toString()));
    }
  }

}

class BoardCommentModel {
  final String id;
  final String comment;
  final DateTime? editedAt;
  final DateTime? createdAt;
  final String cardSlug;
  final String cardTitle;
  final List<BoardCommentFileModel> files;

  BoardCommentModel({
    required this.id,
    required this.comment,
    this.editedAt,
    this.createdAt,
    required this.cardSlug,
    required this.cardTitle,
    required this.files,
  });

  factory BoardCommentModel.fromJson(Map<String, dynamic> json) {
    return BoardCommentModel(
      id: json["id"] ?? "",
      comment: json["comment"] ?? "",
      editedAt: json["edited_at"] != null ? DateTime.parse(json["edited_at"]) : null,
      createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
      cardSlug: json["card"]?["slug"] ?? "",
      cardTitle: json["card"]?["title"] ?? "",
      files: (json["files"] as List<dynamic>? ?? [])
          .map((e) => BoardCommentFileModel.fromJson(e))
          .toList(),
    );
  }
}

class BoardCommentFileModel {
  final String name;
  final int size;

  BoardCommentFileModel({
    required this.name,
    required this.size,
  });

  factory BoardCommentFileModel.fromJson(Map<String, dynamic> json) {
    return BoardCommentFileModel(
      name: json["name"] ?? "",
      size: int.tryParse(json["size"]?.toString() ?? "0") ?? 0,
    );
  }
}

class PaginatorInfo {
  final int count;
  final int currentPage;
  final int? firstItem;
  final bool hasMorePages;
  final int? lastItem;
  final int lastPage;
  final int perPage;
  final int total;

  PaginatorInfo({
    required this.count,
    required this.currentPage,
    this.firstItem,
    required this.hasMorePages,
    this.lastItem,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PaginatorInfo.fromJson(Map<String, dynamic> json) {
    return PaginatorInfo(
      count: json["count"] ?? 0,
      currentPage: json["currentPage"] ?? 1,
      firstItem: json["firstItem"],
      hasMorePages: json["hasMorePages"] ?? false,
      lastItem: json["lastItem"],
      lastPage: json["lastPage"] ?? 1,
      perPage: json["perPage"] ?? 10,
      total: json["total"] ?? 0,
    );
  }
}
