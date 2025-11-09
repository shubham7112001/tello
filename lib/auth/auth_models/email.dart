import 'package:formz/formz.dart';

enum EmailValidationError { invalid }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');
  const Email.dirty([super.value = '']) : super.dirty();

static final RegExp _emailRegExp = RegExp(
  r'^[a-z0-9._%+-]+@[a-zA0-9.-]+\.[a-z]{2,}$',
);

  @override
  EmailValidationError? validator(String value) {
    return value.isEmpty || _emailRegExp.hasMatch(value) ? null : EmailValidationError.invalid;
  }
}

extension Explanation on EmailValidationError {
  String? get message {
    switch (this) {
      case EmailValidationError.invalid:
        return "Please enter valid email";
      }
  }
}
