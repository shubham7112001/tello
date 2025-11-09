import 'package:equatable/equatable.dart';

abstract class ForgetPasswordEvent extends Equatable {
  const ForgetPasswordEvent();

  @override
  List<Object?> get props => [];
}

class ForgetPasswordEmailChanged extends ForgetPasswordEvent {
  final String email;
  const ForgetPasswordEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class ForgetPasswordSubmitted extends ForgetPasswordEvent {}
