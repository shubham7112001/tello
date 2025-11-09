import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_bloc_cubit/board_blocs/board_bloc.dart';
import 'package:otper_mobile/app_bloc_cubit/board_blocs/board_drawer_blocs/archived_card_cubit.dart';
import 'package:otper_mobile/app_bloc_cubit/board_blocs/board_drawer_blocs/board_details_cubit.dart';
import 'package:otper_mobile/app_bloc_cubit/board_blocs/board_drawer_blocs/board_drawer_cubit.dart';
import 'package:otper_mobile/app_bloc_cubit/board_blocs/board_drawer_blocs/manage_labels_cubit.dart';
import 'package:otper_mobile/app_bloc_cubit/board_blocs/board_drawer_blocs/manage_member_cubit.dart';
import 'package:otper_mobile/app_bloc_cubit/card_page_blocs/attachment_cubit.dart';
import 'package:otper_mobile/app_bloc_cubit/card_page_blocs/description_cubit.dart';
import 'package:otper_mobile/app_bloc_cubit/card_page_blocs/members_cubit.dart';
import 'package:otper_mobile/app_bloc_cubit/card_page_blocs/quick_action_cubit.dart';
import 'package:otper_mobile/app_bloc_cubit/checklist_blocs/checklist_cubit.dart';
import 'package:otper_mobile/app_bloc_cubit/date_time_drop_down_cubit.dart';
import 'package:otper_mobile/app_bloc_cubit/home_team_blocs/home_team_cubit.dart';
import 'package:otper_mobile/app_bloc_cubit/internet_connectivity/connectivity_cubit.dart';
import 'package:otper_mobile/app_bloc_cubit/logout_cubit.dart';
import 'package:otper_mobile/app_bloc_cubit/zoom/zoom_bloc.dart';
import 'package:otper_mobile/auth/auth_navigation_bloc.dart';
import 'package:otper_mobile/auth/login/login_cubit.dart';
import 'package:otper_mobile/auth/sign_up/sign_up_bloc.dart';
import 'package:otper_mobile/auth/forget_password/forget_password_bloc.dart';
import 'package:otper_mobile/utils/app_widgets/horizontal_scroller.dart';

class AppBlocProviders {
  static final List<BlocProvider> providers = [
    BlocProvider<SignUpBloc>(create: (_) => SignUpBloc()),
    BlocProvider<LoginCubit>(create: (_) => LoginCubit()),
    BlocProvider<ForgetPasswordBloc>(create: (_) => ForgetPasswordBloc()),
    BlocProvider<ImageScrollCubit>(create: (_) => ImageScrollCubit()),
    BlocProvider<QuickActionsCubit>(create: (_) => QuickActionsCubit()),
    BlocProvider<DescriptionCubit>(create: (_) => DescriptionCubit()),
    BlocProvider<AttachmentCubit>(create: (_) => AttachmentCubit()),
    BlocProvider<AuthBloc>(
      create: (_) => AuthBloc()..add(CheckAuthStatus()),
    ),
    BlocProvider<HomeTeamCubit>(create: (_) => HomeTeamCubit()),
    BlocProvider<BoardBloc>(create: (_) => BoardBloc()),
    BlocProvider<ConnectivityCubit>(create: (_) => ConnectivityCubit()),
    BlocProvider<ZoomBloc>(create: (_) => ZoomBloc()),
    BlocProvider<ChecklistCubit>(create: (_) => ChecklistCubit()),
    BlocProvider<DateTimeDropdownCubit>(create: (_) => DateTimeDropdownCubit()),
    BlocProvider<MembersCubit>(create: (_) => MembersCubit()),
    BlocProvider<LabelCubit>(create: (_) => LabelCubit()),
    BlocProvider<BoardDrawerCubit>(create: (_) => BoardDrawerCubit()),
    BlocProvider<ArchivedCardsCubit>(create: (_) => ArchivedCardsCubit()),
    BlocProvider<ManageMembersCubit>(create: (_) => ManageMembersCubit()),
    BlocProvider<LogoutCubit>(create: (_) => LogoutCubit()),
    
  ];
}