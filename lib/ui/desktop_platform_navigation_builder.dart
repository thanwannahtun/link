import 'package:flutter/material.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/ui/utils/route_list.dart';

class DesktopPlatformNavigationBuilder extends StatefulWidget {
  const DesktopPlatformNavigationBuilder(
      {super.key,
      this.isExtended = false,
      required this.selectedDestinationIndex,
      this.onDestinationSelected});

  final bool isExtended;
  final int selectedDestinationIndex;
  final ValueChanged<int>? onDestinationSelected;

  @override
  State<DesktopPlatformNavigationBuilder> createState() =>
      _DesktopPlatformNavigationBuilderState();
}

class _DesktopPlatformNavigationBuilderState
    extends State<DesktopPlatformNavigationBuilder> {
  late int _selectedIndex;

  @override
  void initState() {
    _selectedIndex = widget.selectedDestinationIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // final isExtended = MediaQuery.sizeOf(context).width > 1000;

    return Container(
      width: widget.isExtended ? 200 : 100,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: colorScheme.tertiaryContainer,
            width: 3.0,
          ),
        ),
      ),
      child: Stack(children: [
        NavigationRail(
          extended: widget.isExtended,
          labelType: widget.isExtended
              ? NavigationRailLabelType.none
              : NavigationRailLabelType.all,
          selectedIndex: _selectedIndex,
          groupAlignment: -1,
          indicatorColor: Colors.blue.shade300,
          useIndicator: true,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
              widget.onDestinationSelected?.call(index);
            });
          },
          leading: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                FloatingActionButton.extended(
                  key: const Key('upload_fab'),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  // backgroundColor: colorScheme.tertiaryContainer,
                  backgroundColor: Colors.blue.shade800,
                  foregroundColor: colorScheme.onPrimaryContainer,
                  onPressed: () {
                    context.pushNamed(RouteLists.uploadNewPost);
                  },
                  label: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          destinations: List.generate(destinations.length, (index) {
            final d = destinations[index];
            final isSelected = _selectedIndex == index;
            return NavigationRailDestination(
              indicatorColor: Colors.blue.shade800,
              icon: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.shade800 : null,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(
                  d.icon,
                  color: isSelected
                      ? Colors.blue.shade800
                      : colorScheme.onSurfaceVariant,
                ),
              ),
              selectedIcon: Icon(
                d.selectedIcon,
                color: Colors.blue.shade800,
              ),
              label: Text(
                d.label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? Colors.blue.shade800
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            );
          }),
        ),
        Positioned(
          left: widget.isExtended ? 50 : 20,
          right: widget.isExtended ? 50 : 20,
          bottom: 20,
          child: Column(
            children: [
              FloatingActionButton.small(
                key: const Key('profile_fab'),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                backgroundColor: context.successColor,
                onPressed: () {
                  context.pushNamed(RouteLists.profileScreen);
                },
                child: const Icon(Icons.person),
              ),
            ],
          ),
        )

        ///
      ]),
    );
  }
}

class Destination {
  const Destination(this.icon, this.label, this.selectedIcon);

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

const List<Destination> destinations = <Destination>[
  Destination(
    Icons.home_outlined,
    'Home',
    Icons.home,
  ),
  Destination(Icons.search_rounded, 'Hot', Icons.search),
  Destination(Icons.history_rounded, 'History', Icons.history),
  // Destination(Icons.group_outlined, 'Groups'),
];
