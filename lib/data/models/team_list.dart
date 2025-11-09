import 'package:otper_mobile/data/models/home_team_model.dart';

class TeamList {
  final List<HomeTeamModel>? teams;

  TeamList({this.teams});

  factory TeamList.fromJson(Map<String, dynamic> json) {
    return TeamList(
      teams: (json['teams'] as List<dynamic>?)
          ?.map((e) => HomeTeamModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teams': teams?.map((e) => e.toJson()).toList(),
    };
  }
}
