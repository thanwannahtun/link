import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/bloc/bottom_select/bottom_select_cubit.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/core/utils/app_insets.dart';

// ignore: must_be_immutable
class AppBottomNavigationBar extends StatefulWidget {
  const AppBottomNavigationBar({super.key});

  // ValueChanged<NavigationStates?>? onDoubleTap;
  @override
  State<AppBottomNavigationBar> createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  final List<BottomNavigationBarItem> items = [
    const BottomNavigationBarItem(
      activeIcon: Tooltip(
          message: 'Home', child: Icon(Icons.home_rounded)),
      icon: Tooltip(message: 'Home', child: Icon(Icons.home_outlined)),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      activeIcon: Tooltip(
          message: 'Hot', child: Icon(Icons.search_rounded, fill: 1)),
      icon: Tooltip(message: 'Hot', child: Icon(Icons.search_rounded)),
      label: 'Hot',
    ),
    const BottomNavigationBarItem(
      activeIcon: Tooltip(
          message: 'Activity', child: Icon(Icons.history,fill: 1)),
      icon: Tooltip(message: 'Activity', child: Icon(Icons.history_rounded)),
      label: 'Activity',
    ),
    const BottomNavigationBarItem(
      activeIcon: Tooltip(
          message: 'Profile', child: Icon(Icons.person_rounded)),
      icon: Tooltip(message: 'Profile', child: Icon(Icons.person_outlined)),
      label: 'Profile',
    ),
  ];

  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = NavigationStates.home.index;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        debugPrint(
            "[NavigationStates] onDoubleTap ::: currentIndex => ${NavigationStates.values[_currentIndex]} ");
        context
            .read<BottomSelectCubit>()
            .navigateTo(state: NavigationStates.values[_currentIndex]);
        setState(() {});
        // widget.onDoubleTap!(NavigationStates
        //     .values[context.read<BottomSelectCubit>().state.index]);
        // context.read<BottomSelectCubit>().doubleTap(
        //     currentState: NavigationStates
        //         .values[context.read<BottomSelectCubit>().state.index]);
      },
      child: BottomNavigationBar(
        iconSize: AppInsets.inset20,
        items: items,
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        currentIndex: context.read<BottomSelectCubit>().state.index,
        showUnselectedLabels: true,
        selectedItemColor: context.successColor,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          _currentIndex = index;
          context
              .read<BottomSelectCubit>()
              .navigateTo(state: NavigationStates.values[index]);
          setState(() {});
        },
      ),
    );
  }
}
