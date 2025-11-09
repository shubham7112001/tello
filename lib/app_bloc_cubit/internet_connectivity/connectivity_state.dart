part of 'connectivity_cubit.dart';

class ConnectivityState extends Equatable {
  final bool isConnected;

  const ConnectivityState._(this.isConnected);
  const ConnectivityState.initial() : this._(true);
  const ConnectivityState.online() : this._(true);
  const ConnectivityState.offline() : this._(false);

  @override
  List<Object> get props => [isConnected];
}
