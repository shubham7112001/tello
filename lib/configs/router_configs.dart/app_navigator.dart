import 'package:go_router/go_router.dart';
import 'package:otper_mobile/configs/router_configs.dart/app_routes.dart';
import 'package:otper_mobile/data/models/home_board_model.dart';

class AppNavigator {
  static late GoRouter router;

  static void init(GoRouter r) => router = r;

  static void goToLogin({bool clearStack = false}) {
    clearStack
        ? router.goNamed(RouteNames.login)   // replace stack
        : router.pushNamed(RouteNames.login); // add to stack
  }

  static void goToSignUp({bool clearStack = false}) {
    clearStack
        ? router.goNamed(RouteNames.signup)
        : router.pushNamed(RouteNames.signup);
  }

  static void goToForgetPassword({bool clearStack = false}) {
    clearStack
        ? router.goNamed(RouteNames.forgetPassword)
        : router.pushNamed(RouteNames.forgetPassword);
  }

  static void goToHome({bool clearStack = false}) {
    clearStack
        ? router.goNamed(RouteNames.home)
        : router.pushNamed(RouteNames.home);
  }

  static void goToBoard({bool clearStack = false, required HomeBoardModel homeBoard}) {
    clearStack
        ? router.goNamed(
          RouteNames.board,
          extra: homeBoard
        )
        : router.pushNamed(
          RouteNames.board,
          extra: homeBoard
        );
  }

  static void goToCard({bool clearStack = false, required String slug, required String title, required String boardId}) {
    final extraData = {'slug': slug, 'title': title, 'boardId': boardId};
    clearStack
        ? router.goNamed(
          RouteNames.card,
          extra: extraData
        )
        : router.pushNamed(
          RouteNames.card,
          extra: extraData
        );
  }

  static void goToManageLabels({bool clearStack = false, required HomeBoardModel homeBoard}) {
    clearStack
        ? router.goNamed(RouteNames.manageLabels, extra: homeBoard)
        : router.pushNamed(RouteNames.manageLabels, extra: homeBoard);
  }

  static void goToManageLists({bool clearStack = false, required HomeBoardModel homeBoard}) {
    clearStack
        ? router.goNamed(RouteNames.manageList, extra: homeBoard)
        : router.pushNamed(RouteNames.manageList, extra: homeBoard);
  }

  static void goToArchivedPage({bool clearStack = false, required HomeBoardModel homeBoard}) {
    clearStack
        ? router.goNamed(RouteNames.archivedCard, extra: homeBoard)
        : router.pushNamed(RouteNames.archivedCard, extra: homeBoard);
  }

  static void goToManageMember({bool clearStack = false, required HomeBoardModel homeBoard}) {
    clearStack
        ? router.goNamed(RouteNames.manageMember, extra: homeBoard)
        : router.pushNamed(RouteNames.manageMember, extra: homeBoard);
  }

  static void goToBoardActivity({bool clearStack = false, required HomeBoardModel homeBoard}) {
    clearStack
        ? router.goNamed(RouteNames.boardActivity, extra: homeBoard)
        : router.pushNamed(RouteNames.boardActivity, extra: homeBoard);
  }

  static void goToBoardDetails({bool clearStack = false, required HomeBoardModel homeBoard}) {
    clearStack
        ? router.goNamed(
          RouteNames.boardDetails,
          extra: homeBoard
        )
        : router.pushNamed(
          RouteNames.boardDetails,
          extra: homeBoard
        );
  }



  static void pop<T extends Object?>([T? result]) {
    if (router.canPop()) {
      router.pop(result);
    }
  }
}

