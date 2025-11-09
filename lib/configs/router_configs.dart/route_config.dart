import 'package:go_router/go_router.dart';
import 'package:otper_mobile/app_ui/board/board_page.dart';
import 'package:otper_mobile/app_ui/board/drawer/archived_card.dart';
import 'package:otper_mobile/app_ui/board/drawer/board_activities/board_activity.dart';
import 'package:otper_mobile/app_ui/board/drawer/board_details.dart';
import 'package:otper_mobile/app_ui/board/drawer/manage_member.dart';
import 'package:otper_mobile/app_ui/board/drawer/manage_labels.dart';
import 'package:otper_mobile/app_ui/board/drawer/manage_list.dart';
import 'package:otper_mobile/app_ui/card_page_ui/card_page.dart';
import 'package:otper_mobile/app_ui/home/home_page.dart';
import 'package:otper_mobile/auth/forget_password/forget_password_page.dart';
import 'package:otper_mobile/auth/login/login_page.dart';
import 'package:otper_mobile/auth/sign_up/sign_up_page.dart';
import 'package:otper_mobile/configs/router_configs.dart/app_routes.dart';
import 'package:otper_mobile/data/models/home_board_model.dart';

final routeConfig = GoRouter(
  initialLocation: RoutePaths.login, 
  routes: [
    GoRoute(
      name: RouteNames.login,
      path: RoutePaths.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      name: RouteNames.signup,
      path: RoutePaths.signup,
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      name: RouteNames.forgetPassword,
      path: RoutePaths.forgetPassword,
      builder: (context, state) => const ForgetPasswordPage(),
    ),
    GoRoute(
      name: RouteNames.home,
      path: RoutePaths.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      name: RouteNames.board,
      path: RoutePaths.board,
      builder: (context, state) {
        final board = state.extra as HomeBoardModel;

          return BoardPage(homeBoardModel: board);
        },
    ),

    GoRoute(
      name: RouteNames.card,
      path: RoutePaths.card,
      builder: (context, state) {
        final extra = state.extra as Map<String, String>;
        return CardPage(
          slug: extra['slug']!,
          title: extra['title']!,
          boardId: extra['boardId']!,
        );
      },
    ),

    GoRoute(
      name: RouteNames.manageLabels,
      path: RoutePaths.manageLabels,
      builder: (context, state) {
        final board = state.extra as HomeBoardModel;
          return ManageLabelPage(board: board);
        },
    ),

    GoRoute(
      name: RouteNames.manageList,
      path: RoutePaths.manageList,
      builder: (context, state) {
        final board = state.extra as HomeBoardModel;
          return ManageListPage(board: board);
        },
    ),

    GoRoute(
      name: RouteNames.archivedCard,
      path: RoutePaths.archivedCard,
      builder: (context, state) {
        final board = state.extra as HomeBoardModel;
          return ArchivedCardsPage(board: board);
        },
    ),

    GoRoute(
      name: RouteNames.manageMember,
      path: RoutePaths.manageMember,
      builder: (context, state) {
        final board = state.extra as HomeBoardModel;
          return ManageMembersPage(board: board);
        },
    ),

    GoRoute(
      name: RouteNames.boardActivity,
      path: RoutePaths.boardActivity,
      builder: (context, state) {
        final board = state.extra as HomeBoardModel;
          return BoardActivity(board: board);
        },
    ),

    GoRoute(
      name: RouteNames.boardDetails,
      path: RoutePaths.boardDetails,
      builder: (context, state) {
        final board = state.extra as HomeBoardModel;
          return BoardDetails(board: board);
        },
    ),
  ],

);