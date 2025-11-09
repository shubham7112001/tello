import 'package:formz/formz.dart';

enum PasswordValidationError {
  invalid,
  empty,
}

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

  // static final _passwordRegExp = RegExp(
  //   r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$',
  // );

  @override
  PasswordValidationError? validator(String value) {
    if(value.isNotEmpty &&  value.length < 8)return PasswordValidationError.invalid;
    return null;
  }
}

extension Explanation on PasswordValidationError {
  String get message {
    switch (this) {
      case PasswordValidationError.empty:
        return "Password cannot be empty";
      case PasswordValidationError.invalid:
        return "Password length at least 8";
    }
  }
}
