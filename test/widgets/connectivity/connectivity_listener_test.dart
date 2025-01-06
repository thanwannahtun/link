import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:link/bloc/connectivity/connectivity_bloc.dart';
import 'package:link/main.dart';
import 'package:link/ui/widgets/connectivity/connectiviy_listener.dart';

class _MockConnectivityBloc extends Mock implements ConnectivityBloc {}

void main() {
  late ConnectivityBloc connectivityBloc;

  setUp(() {
    connectivityBloc = _MockConnectivityBloc();
  });

  Widget buildTestableWidget({Widget? child}) {
    return BlocProvider<ConnectivityBloc>.value(
      value: connectivityBloc,
      child: ConnectiviyListener(
          child: MaterialApp(
              scaffoldMessengerKey: scaffoldMessengerKey,
              home: Scaffold(body: child ?? const Text("Test Widget")))),
    );
  }

  group('ConnectivityListener', () {
    testWidgets(
        'displays Snackbar with error type if initial state is disconnected',
        (WidgetTester tester) async {
      // Arrange
      whenListen(
        connectivityBloc,
        initialState: ConnectivityStatus.disconnected,
        Stream<ConnectivityStatus>.fromIterable(
            [ConnectivityStatus.disconnected]),
      );
      // Act
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(ConnectivityStatus.disconnected.status), findsOneWidget);
    });

    testWidgets('does not display Snackbar if initial state is connected',
        (WidgetTester tester) async {
      // Arrange

      whenListen<ConnectivityStatus>(connectivityBloc, const Stream.empty(),
          initialState: ConnectivityStatus.connected);

      // Act
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(ConnectivityStatus.connected.status), findsNothing);
      expect(find.text(ConnectivityStatus.disconnected.status), findsNothing);
    });

    testWidgets('displays Snackbar when transitioning to connected state',
        (WidgetTester tester) async {
      // Arrange
      // Mock the `stream` getter

      whenListen(
        connectivityBloc,
        Stream.fromIterable([
          ConnectivityStatus.disconnected,
          ConnectivityStatus.connected,
        ]),
        initialState: ConnectivityStatus.disconnected,
      );

      // Act
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(ConnectivityStatus.connected.status), findsOneWidget);
    });

    testWidgets('displays Snackbar when transitioning to disconnected state',
        (WidgetTester tester) async {
      // Arrange
      whenListen(
        connectivityBloc,
        Stream.fromIterable([
          ConnectivityStatus.connected,
          ConnectivityStatus.disconnected,
        ]),
        initialState: ConnectivityStatus.connected,
      );

      // Act
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(ConnectivityStatus.disconnected.status), findsOneWidget);
    });

    testWidgets('does not show Snackbar when no states are emitted',
        (WidgetTester tester) async {
      // Arrange: Explicitly override the stream getter
      whenListen(
        connectivityBloc,
        Stream<ConnectivityStatus>.fromIterable([]), // Empty stream
        initialState: ConnectivityStatus.connected,
      );
      // Act: Build the widget and allow state changes
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // Assert: Verify no Snackbar is shown
      expect(find.text(ConnectivityStatus.connected.status), findsNothing);
      expect(find.text(ConnectivityStatus.disconnected.status), findsNothing);
    });

    ///
  });
}
