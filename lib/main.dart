import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otper_mobile/auth/auth_navigation_bloc.dart';
import 'package:otper_mobile/configs/bloc_configs.dart/app_bloc_providers.dart';
import 'package:otper_mobile/configs/router_configs.dart/app_navigator.dart';
import 'package:otper_mobile/configs/router_configs.dart/route_config.dart';
import 'package:otper_mobile/main_initializer.dart';
import 'package:otper_mobile/utils/theme/app_theme.dart';


final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  await MainInitializer.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      child: MultiBlocProvider(
        providers: AppBlocProviders.providers,
        child: BlocListener<AuthBloc, AuthState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state is Authenticated) {
              AppNavigator.goToHome(clearStack: true);
            } else if (state is Unauthenticated) {
              AppNavigator.goToLogin();
            }
          },
          child: MaterialApp.router(
            scaffoldMessengerKey: rootScaffoldMessengerKey,
            color: Colors.white,
            routerConfig: routeConfig,
            title: 'Otper',
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.system,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
          )
        ),
      ),
    );
  }
}
