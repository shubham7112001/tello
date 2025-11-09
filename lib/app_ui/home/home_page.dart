import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_bloc_cubit/home_team_blocs/home_team_cubit.dart';
import 'package:otper_mobile/app_bloc_cubit/home_team_blocs/home_team_state.dart';
import 'package:otper_mobile/app_bloc_cubit/logout_cubit.dart';
import 'package:otper_mobile/app_ui/home/index.dart';
import 'package:otper_mobile/utils/app_widgets/background_widgets.dart';
import 'package:otper_mobile/utils/app_widgets/icons_app.dart';
import 'package:otper_mobile/utils/app_widgets/internet_connectivity.dart';
import 'package:otper_mobile/utils/app_widgets/loader.dart';
import 'package:otper_mobile/utils/constants/app_text_styles.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text(
          "Home",
          style: AppTextStyles.bodyLargeDark,
        ),
        automaticallyImplyLeading: false,
        actions: [
          BlocBuilder<LogoutCubit, LogoutState>(
            builder: (context, state) {
              if (state is LogoutLoading) {
                return const Center(child: Loader());
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Tooltip(
                  message: "Logout",
                  waitDuration: Duration(milliseconds: 500),
                  child: InkWell(
                    onTap: () {
                      context.read<LogoutCubit>().logout();
                    },
                    child: MediumLargeIcon(Icons.logout_sharp),
                  ),
                ),
              );
            },
          )

        ]
      ),
      body: AppBackgroundWidgets(
        child: BlocProvider(
          create: (context) {
            final cubit = HomeTeamCubit();
            cubit.loadTeams(); // start loading
            return cubit;
          },
          child: InternetConnectivity(
            child: BlocBuilder<HomeTeamCubit, HomeTeamState>(
              builder: (context, state) {
                if (state is HomeTeamLoading) {
                  return const Center(child: Loader());
                } else if (state is HomeTeamError) {
                  return Center(child: Text(state.message));
                } else if (state is HomeTeamLoaded) {
                  return HomeView(teams: state.teams,);
                }
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }
}
