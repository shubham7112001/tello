import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:otper_mobile/auth/auth_models/email.dart';
import 'package:otper_mobile/auth/common/auth_background_widgets.dart';
import 'package:otper_mobile/auth/common/auth_button.dart';
import 'package:otper_mobile/auth/common/auth_text_field.dart';
import 'package:otper_mobile/auth/common/welcome_text.dart';
import 'package:otper_mobile/auth/forget_password/forget_password_bloc.dart';
import 'package:otper_mobile/auth/forget_password/forget_password_event.dart';
import 'package:otper_mobile/auth/forget_password/forget_password_state.dart';
import 'package:otper_mobile/configs/router_configs.dart/app_navigator.dart';
import 'package:otper_mobile/utils/constants/app_icons.dart';
import 'package:otper_mobile/utils/constants/app_texts.dart';

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgetPasswordBloc(),
      child: Scaffold(
        body: AuthBackGroundWidgets(
          child: BlocListener<ForgetPasswordBloc, ForgetPasswordState>(
            listener: (context, state) {
              if (state.status.isSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password reset email sent')),
                );
                AppNavigator.goToLogin();
              } else if (state.status.isFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage ?? 'Error')),
                );
              }
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WelcomeText(text: "Forgot Password"),
                  Center(child: Text(AppTexts.forgetPasswordText, style: Theme.of(context).textTheme.labelLarge,textAlign: TextAlign.center,)),
                  SizedBox(height: 40),
                  _ForgetPasswordTextField(),
                  const SizedBox(height: 20),
                  AuthButton(text: "Send Password Reset Link", onPressed: () => AppNavigator.goToLogin())
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ForgetPasswordTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgetPasswordBloc, ForgetPasswordState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: AuthTextField(
            hint: 'Enter your email',
            isRequiredField: true,
            keyboardType: TextInputType.text,
            iconData: AppIcons.email,
            onChanged: (email) => context.read<ForgetPasswordBloc>().add(ForgetPasswordEmailChanged(email)),
            error: state.email.error?.message ?? '',
          ),
        );
      },
    );
  }
}