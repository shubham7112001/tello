import 'package:equatable/equatable.dart';
import 'package:otper_mobile/auth/auth_models/confirm_password.dart';
import 'package:otper_mobile/auth/auth_models/email.dart';
import 'package:otper_mobile/auth/auth_models/name.dart';
import 'package:otper_mobile/auth/auth_models/password.dart';
import 'package:formz/formz.dart';
import 'package:otper_mobile/auth/auth_models/user_name.dart';

class SignUpState extends Equatable{
  const SignUpState({
    this.name = const Name.pure(),
    this.userName = const UserName.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const ConfirmPassword.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.message,
    this.fieldErrors,
  });

  final Name name;
  final Email email;
  final UserName userName;
  final Password password;
  final ConfirmPassword confirmPassword;
  final FormzSubmissionStatus status;
  final String? message;
  final Map<String, dynamic>? fieldErrors;


  @override
  List<Object?> get props => [
    name,
    email,
    password,
    confirmPassword,
    userName,
    status,
    message,
    fieldErrors,
  ];

  SignUpState copyWith({
    Name? name,
    Email? email,
    UserName? userName,
    Password? password,
    ConfirmPassword? confirmPassword,
    FormzSubmissionStatus? status,
    String? message,
    Map<String, dynamic>? fieldErrors,
  }) {
    return SignUpState(
      name: name ?? this.name,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      status: status ?? this.status,
      message: message ?? this.message,
      fieldErrors: fieldErrors ?? this.fieldErrors,
    );
  }
}