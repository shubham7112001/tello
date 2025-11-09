import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final Connectivity _connectivity = Connectivity();
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  bool _hasGoneOffline = false;

  ConnectivityCubit() : super(const ConnectivityState.initial()) {
    _initConnectivity();

    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      _updateStatus(results);
    });
  }

  Future<void> _initConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    if (results.contains(ConnectivityResult.none)) {
      _updateStatus(results);
    }
  }

  void _updateStatus(List<ConnectivityResult> results,) {
    final isOffline = results.contains(ConnectivityResult.none) && results.length == 1;

    if (isOffline) {
      _hasGoneOffline = true;
      emit(const ConnectivityState.offline());
    } else {
      if (_hasGoneOffline) {
        emit(const ConnectivityState.online());
      }
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
