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
      const currentState = NavigationStates.activity;

      test(
        "Initial state is ${NavigationStates.home}",
        () => expect(sut.state, NavigationStates.home),
      );

      blocTest<BottomSelectCubit, NavigationStates>(
        "navigate to ${NavigationStates.explore}",
        build: () {
          return sut;
        },
        seed: () => NavigationStates.home,
        act: (cubit) => cubit.navigateTo(state: NavigationStates.explore),
        expect: () => [NavigationStates.explore],
      );

      blocTest<BottomSelectCubit, NavigationStates>(
        "current state is $currentState and navigate to ${NavigationStates.home} and keep navigating to $currentState",
        build: () {
          return sut;
        },
        seed: () => currentState,
        act: (cubit) => cubit
          ..navigateTo(state: NavigationStates.home)
          ..navigateTo(state: currentState),
        expect: () => [NavigationStates.home, currentState],
      );
    },
  );
}
