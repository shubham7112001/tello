import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:otper_mobile/auth/auth_models/email.dart';
import 'package:otper_mobile/auth/auth_models/password.dart';
import 'package:otper_mobile/auth/common/auth_bottom_text.dart';
import 'package:otper_mobile/auth/common/auth_button.dart';
import 'package:otper_mobile/auth/common/auth_text_field.dart';
import 'package:otper_mobile/auth/common/welcome_text.dart';
import 'package:otper_mobile/configs/router_configs.dart/app_navigator.dart';
import 'package:otper_mobile/utils/app_widgets/loader.dart';
import 'package:otper_mobile/utils/constants/app_icons.dart';
import 'package:otper_mobile/utils/constants/app_text_styles.dart';
import 'login_cubit.dart';
import 'login_state.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  _authBottomText(){
    return AuthBottomText(text: "Don't have an account?",buttonText: "Sign Up",onPressed: () => AppNavigator.goToSignUp(),);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          // if (state.status.isFailure && state.errorMessage != null) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text(state.errorMessage!)),
          //   );
          // } else if (state.status.isSuccess) {
          //   log('success');
          // }
        },
        builder: (context, state) => Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WelcomeText(text: "Please login to continue"),
                    _EmailInputField(),
                    _PasswordInputField(),
                    _ForgetPasswordText(),
                    _LoginButton(),
                    _authBottomText(),
                    if (state.status.isFailure && state.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          state.errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            state.status.isInProgress
                ? Positioned(
              child: Align(
                alignment: Alignment.center,
                child: Loader(),
              ),
            ) : Container(),
          ],
        )
    );
  }
}

class _ForgetPasswordText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(onTap:() => AppNavigator.goToForgetPassword(), child: Text("Forgot password?", style: AppTextStyles.textButtonStyle,)),
        ],
      ),
    );
  }
}

class _EmailInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return AuthTextField(
          hint: 'Email',
          keyboardType: TextInputType.emailAddress,
          error: state.email.error?.message ?? '',
          iconData: AppIcons.email,
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
        );
      },
    );
  }
}

class _PasswordInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return AuthTextField(
          padding: EdgeInsets.symmetric(vertical: 20),
          hint: 'Password',
          isPasswordField: true,
          keyboardType: TextInputType.text,
          error: state.password.error?.message ?? '',
          iconData: AppIcons.password,
          onChanged: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton() ;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return AuthButton(
          text: state.status.isInProgress ? "Logging in" : "Log in",
          onPressed: state.status.isInProgress
              ? null
              : () => context.read<LoginCubit>().logInWithCredentials(),
        );
      },
    );
  }
}