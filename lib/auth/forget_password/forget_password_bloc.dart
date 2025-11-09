import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:otper_mobile/auth/auth_models/email.dart';
import 'package:otper_mobile/auth/forget_password/forget_password_event.dart';
import 'package:otper_mobile/auth/forget_password/forget_password_state.dart';

class ForgetPasswordBloc extends Bloc<ForgetPasswordEvent, ForgetPasswordState> {

  ForgetPasswordBloc() : super(const ForgetPasswordState()) {
    on<ForgetPasswordEmailChanged>(_onEmailChanged);
    on<ForgetPasswordSubmitted>(_onSubmitted);
  }

  void _onEmailChanged(
    ForgetPasswordEmailChanged event,
    Emitter<ForgetPasswordState> emit,
  ) {
    final email = Email.dirty(event.email);
    emit(state.copyWith(email: email));
  }

  Future<void> _onSubmitted(
    ForgetPasswordSubmitted event,
    Emitter<ForgetPasswordState> emit,
  ) async {
    if (!state.email.isValid) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
