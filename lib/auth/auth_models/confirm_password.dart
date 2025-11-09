import 'package:formz/formz.dart';

enum ConfirmedPasswordValidationError {
  invalid,
  mismatch,
}

class ConfirmPassword extends FormzInput<String, ConfirmedPasswordValidationError> {
  final String password;

  const ConfirmPassword.pure({this.password = ''}) : super.pure('');
  const ConfirmPassword.dirty({
    required this.password,
    String value = '',
  }) : super.dirty(value);

  @override
  ConfirmedPasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return null;
    }
    return password == value ? null : ConfirmedPasswordValidationError.mismatch;
  }
}

extension Explanation on ConfirmedPasswordValidationError {
  String get message {
    switch (this) {
      case ConfirmedPasswordValidationError.invalid:
        return 'Password cannot be empty';
      case ConfirmedPasswordValidationError.mismatch:
        return 'Passwords must match';
    }
  }
}
