import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:otper_mobile/auth/auth_models/email.dart';
import 'package:otper_mobile/auth/auth_models/password.dart';
import 'package:otper_mobile/data/api/api_exception.dart';
import 'package:otper_mobile/data/repositories/auth_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password
    ));
  }

  Future<void> logInWithCredentials() async {
    debugPrint("login Function called");
    final AuthRepository authRepository = AuthRepository();

    if (state.email.value.isEmpty) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: "Please enter email",
      ));
      return;
    }

    if (state.password.value.isEmpty) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: "Please enter password",
      ));
      return;
    }
    // Validate inputs
    if (!state.email.isValid) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: "Please enter valid email",
      ));
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      await authRepository.login(
        state.email.value,
        state.password.value,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on NetworkException {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: "No internet connection. Please try again.",
      ));
    } on AuthException {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: "Invalid credentials. Please check your email or password.",
      ));
    } on ServerException {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: "Server error. Please try again later.",
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: "Unexpected error occurred. Please try again.",
      ));
    }
  }
}