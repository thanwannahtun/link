import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

enum ConnectivityStatus {
  connected("network restored"),
  disconnected("network disconnected");

  const ConnectivityStatus(this.status);

  final String status;
}

class ConnectivityBloc extends Cubit<ConnectivityStatus> {
  // final Connectivity _connectivity = Connectivity();
  late final Connectivity _connectivity;

  late final StreamSubscription<List<ConnectivityResult>>
      _connectivitySubscription;

  ConnectivityBloc({required Connectivity connectivity})
      : super(ConnectivityStatus.disconnected) {
    _connectivity = connectivity;
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) {
      emit(_mapConnectivityResultToStatus(result));
    });
  }

  ConnectivityStatus _mapConnectivityResultToStatus(
      List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi)) {
      return ConnectivityStatus.connected;
    } else {
      return ConnectivityStatus.disconnected;
    }
  }

  @override
  Future<void> close() async {
    await _connectivitySubscription.cancel();
    return super.close();
  }
}
