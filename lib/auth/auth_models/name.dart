import 'package:formz/formz.dart';

enum NameError {
  empty,
  invalid
}

class Name extends FormzInput<String, NameError> {
  const Name.pure([super.value = '']) : super.pure();
  const Name.dirty([super.value = '']) : super.dirty();

  static final RegExp _nameRegExp = RegExp(
    r'^[A-Za-z ]+$',
  );

  @override
  NameError? validator(String value) {
    if (value.isEmpty) {
      return null;
    }
    return _nameRegExp.hasMatch(value) ? null : NameError.invalid;
  }

}

extension Explanation on NameError {
  String get message {
    switch (this) {
      case NameError.empty:
        return "Name cannot be empty";
      case NameError.invalid:
        return "Name contains only alphabets";
    }
  }
}