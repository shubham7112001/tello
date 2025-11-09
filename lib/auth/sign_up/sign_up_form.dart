import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:otper_mobile/auth/auth_models/confirm_password.dart';
import 'package:otper_mobile/auth/auth_models/email.dart';
import 'package:otper_mobile/auth/auth_models/name.dart';
import 'package:otper_mobile/auth/auth_models/password.dart';
import 'package:otper_mobile/auth/auth_models/user_name.dart';
import 'package:otper_mobile/auth/common/auth_bottom_text.dart';
import 'package:otper_mobile/auth/common/auth_button.dart';
import 'package:otper_mobile/auth/common/auth_text_field.dart';
import 'package:otper_mobile/auth/common/welcome_text.dart';
import 'package:otper_mobile/auth/sign_up/sign_up_bloc.dart';
import 'package:otper_mobile/auth/sign_up/sign_up_event.dart';
import 'package:otper_mobile/auth/sign_up/sign_up_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/configs/router_configs.dart/app_navigator.dart';
import 'package:otper_mobile/utils/app_widgets/loader.dart';
import 'package:otper_mobile/utils/constants/app_icons.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
      },
      child: BlocBuilder<SignUpBloc, SignUpState>(
        buildWhen: (previous, current) => previous.status != previous.status,
        builder: (context, state) {
          log("BlocBuilder rebuild: ${state.status}");
          return Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      WelcomeText(text: "Create an account"),
                      _NameInputField(),
                      _EmailInputField(),
                      _UserNameInputField(),
                      _PasswordInputField(),
                      _ConfirmPasswordInput(),
                      _SignUpButton(),
                      AuthBottomText(
                        text: "Already have an account?",
                        buttonText: "Log in",
                        onPressed: () => AppNavigator.goToLogin(),
                      )
                    ],
                  ),
                ),
              ),
               if (state.status.isInProgress)
                Positioned.fill(
                  child: Center(
                    child: Loader(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}


class _NameInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: AuthTextField(
            hint: 'Enter your name',
            isRequiredField: true,
            keyboardType: TextInputType.text,
            iconData: AppIcons.name,
            error: state.name.error?.message,
            onChanged: (name) => context.read<SignUpBloc>().add(NameChanged(name: name)),
          ),
        );
      },
    );
  }
}

class _UserNameInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.userName != current.userName,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: AuthTextField(
            hint: 'Enter your username',
            isRequiredField: true,
            keyboardType: TextInputType.text,
            iconData: AppIcons.username,
            error: state.userName.error?.message,
            onChanged: (userName) => context.read<SignUpBloc>().add(UserNameChanged(userName: userName)),
          ),
        );
      },
    );
  }
}

class _EmailInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: AuthTextField(
            hint: 'Enter your email',
            isRequiredField: true,
            keyboardType: TextInputType.emailAddress,
            error: state.email.error?.message ?? '',
            iconData: AppIcons.email,
            onChanged: (email) => context.read<SignUpBloc>().add(EmailChanged(email: email)),
          ),
        );
      },
    );
  }
}

class _PasswordInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: AuthTextField(
            hint: 'Enter your password',
            isPasswordField: true,
            isRequiredField: true,
            keyboardType: TextInputType.text,
            error: state.password.error?.message ?? '',
            iconData: AppIcons.password,
            onChanged: (password) =>
                context.read<SignUpBloc>().add(PasswordChanged(password: password)),
          ),
        );
      },
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
      previous.password != current.password ||
          previous.confirmPassword != current.confirmPassword,
      builder: (context, state) {
        return AuthTextField(
          hint: 'Re-enter your Password',
          isRequiredField: true,
          isPasswordField: true,
          keyboardType: TextInputType.text,
          error: state.confirmPassword.error?.message ?? '',
          iconData: AppIcons.password,
          onChanged: (confirmPassword) => context
              .read<SignUpBloc>()
              .add(ConfirmPasswordChanged(confirmPassword: confirmPassword)),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return AuthButton(text: "Sign Up", 
          onPressed: () {
              context.read<SignUpBloc>().add(FormSubmitted());
          }

        );
      },
    );
  }
}