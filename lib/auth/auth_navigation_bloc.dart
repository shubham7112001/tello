import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:otper_mobile/data/db/auth_db/auth_db_helper.dart';

/// --------------------
/// Events
/// --------------------
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatus extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String token;

  const LoginRequested({required this.email, required this.token});

  @override
  List<Object?> get props => [email, token];
}

class LogoutRequested extends AuthEvent {}

/// --------------------
/// States
/// --------------------
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final String email;
  final String token;

  const Authenticated({required this.email, required this.token});

  @override
  List<Object?> get props => [email, token];
}

class Unauthenticated extends AuthState {}

/// --------------------
/// Bloc
/// --------------------
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthDbHelper _dbHelper = AuthDbHelper.instance;

  AuthBloc() : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatus event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final loginData = await _dbHelper.getLatestLogin();
    if (loginData != null && loginData.token.isNotEmpty) {
      emit(Authenticated(email: loginData.email, token: loginData.token));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await _dbHelper.insertLogin(email: event.email, token: event.token);
    emit(Authenticated(email: event.email, token: event.token));
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await _dbHelper.deleteAllLogins();
    emit(Unauthenticated());
  }
}
