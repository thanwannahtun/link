import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/bloc/bottom_select/bottom_select_cubit.dart';
import 'package:link/ui/screens/app_bottom_navigation_bar.dart';
import 'package:link/ui/sections/profile/profile_screen.dart';
import 'package:link/ui/sections/hot_and_trending/hot_and_trending_screen.dart';

import '../../bloc/routes/post_route_cubit.dart';
import '../../repositories/post_route.dart';
import '../sections/hero_home/hero_home_screen.dart';
import '../sections/user_activity/user_activity_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<BottomSelectCubit, NavigationStates>(
        builder: (context, state) {
          return IndexedStack(
            index: toggleIndexedScreen(state),
            children: [
              BlocProvider(
                  create: (BuildContext context) => PostRouteCubit(
                      postRouteRepo: context.read<PostRouteRepo>()),
                  child: const HeroHomeScreen()),
              BlocProvider(
                  create: (BuildContext context) => PostRouteCubit(
                      postRouteRepo: context.read<PostRouteRepo>()),
                  child: const ShowRoutesByCategoryScreen()),
              // const HotAndTrendingScreen(),
              const UserActivityScreen(),
              const ProfileScreen(),
            ],
          );
        },
        listener: (context, state) {},
      ),
      bottomNavigationBar: const AppBottomNavigationBar(),
    );
  }

  int toggleIndexedScreen(NavigationStates state) {
    switch (state) {
      case NavigationStates.A:
        return 0;
      case NavigationStates.B:
        return 1;
      case NavigationStates.C:
        return 2;
      case NavigationStates.D:
        return 3;
      default:
        return 0;
    }
  }
}
