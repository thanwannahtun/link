import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:link/bloc/bottom_select/bottom_select_cubit.dart';

void main() {
  late BottomSelectCubit sut;

  setUp(() {
    sut = BottomSelectCubit();
  });

  group(
    BottomSelectCubit,
    () {
      const currentState = NavigationStates.C;

      test(
        "Initial state is ${NavigationStates.A}",
        () => expect(sut.state, NavigationStates.A),
      );

      blocTest<BottomSelectCubit, NavigationStates>(
        "navigate to ${NavigationStates.B}",
        build: () {
          return sut;
        },
        seed: () => NavigationStates.A,
        act: (cubit) => cubit.navigateTo(state: NavigationStates.B),
        expect: () => [NavigationStates.B],
      );

      blocTest<BottomSelectCubit, NavigationStates>(
        "current state is $currentState and navigate to ${NavigationStates.A} and keep navigating to $currentState",
        build: () {
          return sut;
        },
        seed: () => currentState,
        act: (cubit) => cubit
          ..navigateTo(state: NavigationStates.A)
          ..navigateTo(state: currentState),
        expect: () => [NavigationStates.A, currentState],
      );
    },
  );
}
