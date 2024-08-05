import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/bloc/token_validator/token_validator_cubit.dart';
import 'package:link/bloc/authentication/authentication_cubit.dart';
import 'package:link/bloc/bottom_select/bottom_select_cubit.dart';
import 'package:link/ui/screens/app_bottom_navigation_bar.dart';
import 'package:link/ui/screens/profile/profile_screen.dart';
import 'package:link/ui/screens/route_list_screen.dart';
import 'package:link/ui/sections/test.dart';
import 'package:link/ui/utils/route_list.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<BottomSelectCubit, NavigationStates>(
        builder: (context, state) {
          return toggleScreen(state);
        },
        listener: (context, state) {},
      ),
      bottomNavigationBar: const AppBottomNavigationBar(),
    );
  }

  Widget toggleScreen(NavigationStates state) {
    switch (state) {
      case NavigationStates.A:
        return const RouteListScreen();
      case NavigationStates.B:
        return const B();
      case NavigationStates.C:
        return const C();
      case NavigationStates.D:
        return const ProfileScreen();
      default:
        return const RouteListScreen();
    }
  }
}
