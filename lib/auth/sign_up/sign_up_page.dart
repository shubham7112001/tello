import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/auth/common/auth_background_widgets.dart';
import 'package:otper_mobile/auth/sign_up/sign_up_bloc.dart';
import 'package:otper_mobile/auth/sign_up/sign_up_form.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackGroundWidgets(
          child: Center(
            child: BlocProvider(
              create: (_) => SignUpBloc(),
              child: SignUpForm(),
            ),
          ),
        )
    );
  }
}