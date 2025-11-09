import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otper_mobile/data/api/rest_api/auth_api.dart';
import 'package:otper_mobile/utils/helper/helper_function.dart';


abstract class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object?> get props => [];
}

class LogoutInitial extends LogoutState {}

class LogoutLoading extends LogoutState {}

class LogoutSuccess extends LogoutState {
  final Map<String, dynamic> response;
  const LogoutSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class LogoutFailure extends LogoutState {
  final String message;
  const LogoutFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutLoading());

    try {
      final response = await AuthApi().logout(); // 👈 using your logout function

      if (response['status'] == 'success') {
        emit(LogoutSuccess(response));
      } else {
        final msg = response['message'] ?? "Logout failed";
        HelperFunction.showAppSnackBar(message: msg);
        emit(LogoutFailure(msg));
      }
    } catch (e) {
      HelperFunction.showAppSnackBar(message: "Error while logging out");
      emit(const LogoutFailure("Error while logging out"));
    }
  }
}
