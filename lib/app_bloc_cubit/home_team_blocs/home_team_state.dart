import 'package:otper_mobile/data/models/home_team_model.dart';

abstract class HomeTeamState {}

class HomeTeamLoading extends HomeTeamState {}

class HomeTeamLoaded extends HomeTeamState {
  final List<HomeTeamModel> teams;
  HomeTeamLoaded(this.teams);
}

class HomeTeamError extends HomeTeamState {
  final String message;
  HomeTeamError(this.message);
}
