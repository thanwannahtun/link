import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/bloc/connectivity/connectivity_bloc.dart';
import 'package:link/ui/utils/snackbar_util.dart';

import '../../../main.dart';

class ConnectiviyListener extends StatelessWidget {
  const ConnectiviyListener({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    /// Track the first state check
    bool isInitialCheck = true;
    return BlocListener<ConnectivityBloc, ConnectivityStatus>(
      listenWhen: (previous, current) {
        /// Trigger only on state changes (ignore identical states)
        if (isInitialCheck) {
          /// Allow initial state through
          return true;
        }
        return previous != current;
      },
      listener: (BuildContext context, ConnectivityStatus state) {
        if (isInitialCheck) {
          /// Mark initial state as processed
          isInitialCheck = false;

          /// Only show Snackbar if the app starts offline
          if (state == ConnectivityStatus.disconnected) {
            SnackbarUtils.showSnackBar(context, state.status,
                type: state == ConnectivityStatus.disconnected
                    ? SnackBarType.error
                    : SnackBarType.success,
                scaffoldMessengerKey: scaffoldMessengerKey);

            // showGlobalSnackBar(state.status, type: SnackBarType.error);
          }
        } else {
          SnackbarUtils.showSnackBar(context, state.status,
              type: state == ConnectivityStatus.disconnected
                  ? SnackBarType.error
                  : SnackBarType.success,
              scaffoldMessengerKey: scaffoldMessengerKey);

          /// Handle state changes after the initial state
          // showGlobalSnackBar(state.status, type: SnackBarType.success
          // backgroundColor: state.color!,
          // );
        }

        if (kDebugMode) {
          print("Connectivity Changed => ${state.status}");
        }
      },
      child: child,
    );
  }
}
