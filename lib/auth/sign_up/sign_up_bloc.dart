import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:otper_mobile/auth/auth_models/confirm_password.dart';
import 'package:otper_mobile/auth/auth_models/email.dart';
import 'package:otper_mobile/auth/auth_models/name.dart';
import 'package:otper_mobile/auth/auth_models/password.dart';
import 'package:otper_mobile/auth/auth_models/user_name.dart';
import 'package:otper_mobile/configs/router_configs.dart/app_navigator.dart';
import 'package:otper_mobile/data/api/rest_api/api_client.dart';
import 'package:otper_mobile/data/api/rest_api/auth_api.dart';
import 'package:otper_mobile/utils/helper/helper_function.dart';
import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpState()) {
    on<NameChanged>(_onNameChanged);
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<ConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<UserNameChanged>(_onUserNameChanged);
    on<FormSubmitted>(_onFormSubmitted);
  }

  void _onNameChanged(NameChanged event, Emitter<SignUpState> emit) {
    final name = Name.dirty(event.name);
    emit(state.copyWith(
      name: name
    ));
  }

  void _onEmailChanged(EmailChanged event, Emitter<SignUpState> emit) {
    final email = Email.dirty(event.email);
    emit(state.copyWith(
      email: email
    ));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<SignUpState> emit) {
    final password = Password.dirty(event.password);

    emit(state.copyWith(
      password: password
    ));
  }

  void _onConfirmPasswordChanged(
  ConfirmPasswordChanged event,
  Emitter<SignUpState> emit,
) {
  final confirmPassword = ConfirmPassword.dirty(
    password: state.password.value,
    value: event.confirmPassword,
  );

  emit(state.copyWith(
    confirmPassword: confirmPassword,
  ));
}


void _onUserNameChanged(UserNameChanged event, Emitter<SignUpState> emit) {
  final userName = UserName.dirty(event.userName);
  emit(state.copyWith(userName: userName));
}

  Future<void> _onFormSubmitted(
      FormSubmitted event, Emitter<SignUpState> emit) async {

        if (state.status.isInProgress) return;
        emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
        final isAllValid = state.name.isValid &&
          state.name.value.isNotEmpty &&
          state.email.isValid &&
          state.email.value.isNotEmpty &&
          state.userName.isValid &&
          state.userName.value.isNotEmpty &&
          state.password.isValid &&
          state.password.value.isNotEmpty &&
          state.confirmPassword.isValid &&
          state.confirmPassword.value.isNotEmpty &&
          state.password.value == state.confirmPassword.value;

        if (!isAllValid) {
          HelperFunction.showAppSnackBar(
            message: "Please fill all valid details",
            backgroundColor: Colors.redAccent,
          );
          emit(state.copyWith(status: FormzSubmissionStatus.failure));
          return;
        }

        try {
          final AuthApi authApi = AuthApi();
          final res = await authApi.register(
            name: state.name.value,
            email: state.email.value,
            username: state.userName.value,
            password: state.password.value,
            passwordConfirmation: state.confirmPassword.value,
          );
          if(res["name"] != null) {
            HelperFunction.showAppSnackBar(message: "Successfully registered",backgroundColor: Colors.greenAccent);
            AppNavigator.goToLogin();
          }else{
            emit(state.copyWith(
              status: FormzSubmissionStatus.success,
              message: res['message'],
            ));
          }
        } catch (error) {
          // Backend error handling
          if (error is Map<String, dynamic>) {
            if (error.containsKey('errors')) {
              // validation errors
              emit(state.copyWith(
                status: FormzSubmissionStatus.failure,
                fieldErrors: error['errors'], // store field-specific errors
              ));
            } else if (error.containsKey('message')) {
              // general backend errors
              emit(state.copyWith(
                status: FormzSubmissionStatus.failure,
                message: error['message'],
              ));
            }
          } else {
            // network or unknown error
            emit(state.copyWith(
              status: FormzSubmissionStatus.failure,
              message: 'Something went wrong. Please try again.',
            ));
          }
        }
      }


  @override
  void onTransition(Transition<SignUpEvent, SignUpState> transition) {
    super.onTransition(transition);
    print(transition); // Keep this for debugging
  }
}
