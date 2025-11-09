import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:otper_mobile/auth/auth_models/email.dart';

class ForgetPasswordState extends Equatable {
  final Email email;
  final FormzSubmissionStatus status;
  final String? errorMessage;

  const ForgetPasswordState({
    this.email = const Email.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  ForgetPasswordState copyWith({
    Email? email,
    FormzSubmissionStatus? status,
    String? errorMessage,
  }) {
    return ForgetPasswordState(
      email: email ?? this.email,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [email, status, errorMessage];
}
