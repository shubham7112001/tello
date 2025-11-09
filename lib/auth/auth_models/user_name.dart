import 'package:formz/formz.dart';

enum UserNameError {
  empty,
  invalid,
}

class UserName extends FormzInput<String, UserNameError> {
  const UserName.pure([super.value = '']) : super.pure();
  const UserName.dirty([super.value = '']) : super.dirty();

  static final RegExp _userNameRegExp = RegExp(
    r'^[a-z]+$', // only lowercase letters, at least one character
  );

  @override
  UserNameError? validator(String value) {
    if (value.isEmpty) {
      return null;
    }
    return _userNameRegExp.hasMatch(value)
        ? null
        : UserNameError.invalid;
  }
}

extension Explanation on UserNameError {
  String get message {
    switch (this) {
      case UserNameError.empty:
        return "Username cannot be empty";
      case UserNameError.invalid:
        return "Username contains only lowercase alphabets";
    }
  }
}
