import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/app_bloc_cubit/internet_connectivity/connectivity_cubit.dart';
import 'package:otper_mobile/utils/helper/helper_function.dart';

class InternetConnectivity extends StatelessWidget {
  final Widget child;

  const InternetConnectivity({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityCubit, ConnectivityState>(
      listener: (context, state) {
        if (state == ConnectivityState.offline()) {
          HelperFunction.showAppSnackBar(message: 'You are offline', backgroundColor: Colors.red);
        } else if(state == ConnectivityState.online()) {
          HelperFunction.showAppSnackBar(message: 'Back online', backgroundColor: Colors.green);
        }
      },
      child: child,
    );
  }
}
