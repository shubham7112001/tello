import 'package:otper_mobile/data/models/home_board_model.dart';

class HomeTeamModel {
  final String? id;
  final String? name;
  final String? slug;
  final List<HomeBoardModel>? boards;

  HomeTeamModel({
    this.id,
    this.name,
    this.slug,
    this.boards,
  });

  factory HomeTeamModel.fromJson(Map<String, dynamic> json) {
    return HomeTeamModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      boards: (json['boards'] as List<dynamic>?)
          ?.map((e) => HomeBoardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'boards': boards?.map((e) => e.toJson()).toList(),
    };
  }
}