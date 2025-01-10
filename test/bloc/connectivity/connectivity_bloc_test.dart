import 'package:bloc_test/bloc_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:link/bloc/connectivity/connectivity_bloc.dart';
import 'package:mocktail/mocktail.dart';

class _MockConnectivity extends Mock implements Connectivity {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  late Connectivity mockConnectivity;

  setUp(() {
    mockConnectivity = _MockConnectivity();
  });

  group(ConnectivityBloc, () {
    test('initially emits [${ConnectivityStatus.disconnected}]', () async {
      when(() => mockConnectivity.onConnectivityChanged).thenAnswer((_) {
        // return const Stream.empty();
        return const Stream.empty();
      });

      // Assert
      expect(ConnectivityBloc(connectivity: mockConnectivity).state,
          ConnectivityStatus.disconnected);
    });

    blocTest<ConnectivityBloc, ConnectivityStatus>(
      'emits [${ConnectivityStatus.connected}] when network is connected with ${ConnectivityResult.mobile}',
      build: () => ConnectivityBloc(connectivity: mockConnectivity),
      setUp: () {
        when(() => mockConnectivity.onConnectivityChanged).thenAnswer((_) {
          return Stream.value([ConnectivityResult.mobile]);
        });
      },
      expect: () => [ConnectivityStatus.connected],
    );
    blocTest<ConnectivityBloc, ConnectivityStatus>(
      'emits [${ConnectivityStatus.connected}] when network is connected with ${ConnectivityResult.wifi}',
      build: () => ConnectivityBloc(connectivity: mockConnectivity),
      setUp: () {
        when(() => mockConnectivity.onConnectivityChanged).thenAnswer((_) {
          return Stream.value([ConnectivityResult.wifi]);
        });
      },
      expect: () => [ConnectivityStatus.connected],
    );

    blocTest<ConnectivityBloc, ConnectivityStatus>(
      'emits [${ConnectivityStatus.disconnected}] when network is disconnected',
      build: () => ConnectivityBloc(connectivity: mockConnectivity),
      setUp: () {
        when(() => mockConnectivity.onConnectivityChanged).thenAnswer((_) {
          return Stream.value([ConnectivityResult.none]);
        });
      },
      expect: () => [ConnectivityStatus.disconnected],
    );

    blocTest<ConnectivityBloc, ConnectivityStatus>(
      'emits [${ConnectivityStatus.disconnected} , ${ConnectivityStatus.connected}] for network transitions',
      build: () => ConnectivityBloc(connectivity: mockConnectivity),
      setUp: () {
        when(() => mockConnectivity.onConnectivityChanged)
            .thenAnswer((_) => Stream.fromIterable([
                  <ConnectivityResult>[],
                  [ConnectivityResult.mobile],
                ]));
      },
      expect: () => [
        ConnectivityStatus.disconnected,
        ConnectivityStatus.connected,
      ],
    );
    blocTest<ConnectivityBloc, ConnectivityStatus>(
      'emits [${ConnectivityStatus.connected} , ${ConnectivityStatus.disconnected}] for network transitions',
      build: () => ConnectivityBloc(connectivity: mockConnectivity),
      setUp: () {
        when(() => mockConnectivity.onConnectivityChanged).thenAnswer(
          (_) => Stream.fromIterable([
            [ConnectivityResult.wifi],
            <ConnectivityResult>[]
          ]),
        );
      },
      expect: () => [
        ConnectivityStatus.connected,
        ConnectivityStatus.disconnected,
      ],
    );
    blocTest<ConnectivityBloc, ConnectivityStatus>(
      "emits [${ConnectivityStatus.connected}] when multiple connection types are detected",
      build: () => ConnectivityBloc(connectivity: mockConnectivity),
      setUp: () {
        when(() => mockConnectivity.onConnectivityChanged).thenAnswer(
          (_) => Stream.fromIterable([
            [ConnectivityResult.wifi],
            [ConnectivityResult.mobile],
          ]),
        );
      },
      expect: () => [
        ConnectivityStatus.connected,
      ],
    );
  });
}
