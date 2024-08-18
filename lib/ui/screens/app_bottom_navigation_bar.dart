import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/bloc/bottom_select/bottom_select_cubit.dart';

class AppBottomNavigationBar extends StatefulWidget {
  const AppBottomNavigationBar({super.key});

  @override
  State<AppBottomNavigationBar> createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  final List<BottomNavigationBarItem> items = [
    const BottomNavigationBarItem(
      icon: Tooltip(message: 'A', child: Icon(Icons.home_max)),
      label: 'A',
    ),
    const BottomNavigationBarItem(
      icon: Tooltip(message: 'B', child: Icon(Icons.back_hand_outlined)),
      label: 'B',
    ),
    const BottomNavigationBarItem(
      icon: Tooltip(message: 'C', child: Icon(Icons.help_outline)),
      label: 'C',
    ),
    const BottomNavigationBarItem(
      icon: Tooltip(message: 'D', child: Icon(Icons.person)),
      label: 'D',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: items,
      currentIndex: context.read<BottomSelectCubit>().state.index,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        context
            .read<BottomSelectCubit>()
            .navigateTo(state: NavigationStates.values[index]);
        // setState(() {});
      },
    );
  }
}
