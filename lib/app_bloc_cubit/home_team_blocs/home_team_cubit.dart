import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:otper_mobile/app_bloc_cubit/home_team_blocs/home_team_state.dart';
import 'package:otper_mobile/app_graphql/graph_document.dart';
import 'package:otper_mobile/app_graphql/graph_service.dart';
import 'package:otper_mobile/configs/router_configs.dart/app_navigator.dart';
import 'package:otper_mobile/data/models/home_team_model.dart';
import 'package:otper_mobile/utils/helper/helper_function.dart';

// class HomeTeamCubit extends Cubit<List<HomeTeamModel>?> {
//   HomeTeamCubit() : super(null); // null = loading

//   Future<void> loadTeams() async {
//     emit(null); // loading state

//     try {
//       final QueryResult result =
//           await GraphQLService.callGraphQL(query: GraphDocument.getAllTeams);

//         if (result.hasException) {
//         String errorMessage = "Something went wrong";

//         final exception = result.exception!;

//         if (exception.graphqlErrors.isNotEmpty) {
//           errorMessage = exception.graphqlErrors.first.message;
//         } 
//         else if (exception.linkException is ServerException) {
//           final serverException = exception.linkException as ServerException;
//           final response = serverException.parsedResponse?.response;
//           if (response != null && response["message"] != null) {
//             errorMessage = response["message"];
//           }
//         }

//         if(errorMessage.contains("auth")){
//           AppNavigator.goToLogin(clearStack: true);
//         }

//         debugPrint("GraphQL Error: $errorMessage");
//         HelperFunction.showAppSnackBar(message: errorMessage);

//         emit([]); // fallback
//         return;
//       }

//       final data = result.data;
//       debugPrint("GraphQL Raw Data: $data");

//       final List<dynamic>? teamsJson = data?['me']?['teams'];

//       if (teamsJson != null) {
//         final teams = teamsJson.map((teamJson) => HomeTeamModel.fromJson(teamJson)).toList();
//         debugPrint("Parsed Teams: ${teams.map((t) => t.name).toList()}");
//         emit(teams);
//         return;
//       }

//       debugPrint("No teams found in data.");
//       emit([]);
//     } catch (e, st) {
//       debugPrint("Exception loading teams: $e");
//       debugPrint("Stacktrace: $st");
//       emit([]);
//     }
//   }
// }

class HomeTeamCubit extends Cubit<HomeTeamState> {
  HomeTeamCubit() : super(HomeTeamLoading());

  Future<void> loadTeams() async {
    emit(HomeTeamLoading());

    try {
      final QueryResult result =
          await GraphQLService.callGraphQL(query: GraphDocument.getAllTeams);

      if (result.hasException) {
        String errorMessage = "Something went wrong";
        final exception = result.exception!;

        if (exception.graphqlErrors.isNotEmpty) {
          errorMessage = exception.graphqlErrors.first.message;
        } else if (exception.linkException is ServerException) {
          final serverException = exception.linkException as ServerException;
          final response = serverException.parsedResponse?.response;
          if (response != null && response["message"] != null) {
            errorMessage = response["message"];
          }
        }

        if (errorMessage.toLowerCase().contains("auth")) {
          AppNavigator.goToLogin(clearStack: true);
        }

        debugPrint("GraphQL Error: $errorMessage");
        HelperFunction.showAppSnackBar(message: errorMessage);

        emit(HomeTeamError(errorMessage));
        return;
      }

      final data = result.data;
      final List<dynamic>? teamsJson = data?['me']?['teams'];

      if (teamsJson != null) {
        final teams =
            teamsJson.map((teamJson) => HomeTeamModel.fromJson(teamJson)).toList();
        emit(HomeTeamLoaded(teams));
      } else {
        emit(HomeTeamLoaded([]));
      }
    } catch (e, st) {
      debugPrint("Exception loading teams: $e");
      debugPrint("Stacktrace: $st");
      emit(HomeTeamError("Failed to load teams"));
    }
  }
}


