import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/bloc/bottom_select/bottom_select_cubit.dart';
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
      icon: Tooltip(message: 'A', child: Icon(Icons.home)),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Tooltip(message: 'B', child: Icon(Icons.search_rounded)),
      label: 'Hot',
    ),
    const BottomNavigationBarItem(
      icon: Tooltip(message: 'C', child: Icon(Icons.history_rounded)),
      label: 'History',
    ),
    const BottomNavigationBarItem(
      icon: Tooltip(message: 'D', child: Icon(Icons.more_horiz_rounded)),
      label: 'More',
    ),
  ];

  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = NavigationStates.A.index;
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
        currentIndex: context.read<BottomSelectCubit>().state.index,
        showUnselectedLabels: true,
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
