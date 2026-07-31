import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class _AdminDestination {
  const _AdminDestination({
    required this.label,
    required this.icon,
    required this.path,
  });

  final String label;
  final IconData icon;
  final String path;
}

const _destinations = [
  _AdminDestination(
    label: 'Dashboard',
    icon: Icons.dashboard_outlined,
    path: '/admin/dashboard',
  ),
  _AdminDestination(
    label: 'Products',
    icon: Icons.inventory_2_outlined,
    path: '/admin/products',
  ),
  _AdminDestination(
    label: 'Categories',
    icon: Icons.category_outlined,
    path: '/admin/categories',
  ),
];

/// Persistent admin navigation, wrapped around every `/admin/*` route
/// (except login/forgot-password) via a GoRouter `ShellRoute`. Adapts
/// between an extended rail (>=900px), a compact rail (600-899px), and a
/// drawer (<600px) so the same admin pages work on desktop, tablet, and
/// mobile without each page handling layout itself.
class AdminShell extends StatelessWidget {
  const AdminShell({super.key, required this.child});

  final Widget child;

  int _selectedIndex(String location) {
    final index = _destinations.indexWhere((d) => location.startsWith(d.path));
    return index == -1 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final selectedIndex = _selectedIndex(location);
    final width = MediaQuery.sizeOf(context).width;

    void onSelect(int index) => context.go(_destinations[index].path);

    if (width >= 600) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              extended: width >= 900,
              selectedIndex: selectedIndex,
              onDestinationSelected: onSelect,
              destinations: _destinations
                  .map(
                    (d) => NavigationRailDestination(
                      icon: Icon(d.icon),
                      label: Text(d.label),
                    ),
                  )
                  .toList(),
            ),
            const VerticalDivider(width: 1),
            Expanded(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(_destinations[selectedIndex].label)),
      drawer: Drawer(
        child: ListView(
          children: [
            for (var i = 0; i < _destinations.length; i++)
              ListTile(
                leading: Icon(_destinations[i].icon),
                title: Text(_destinations[i].label),
                selected: i == selectedIndex,
                onTap: () {
                  Navigator.of(context).pop();
                  onSelect(i);
                },
              ),
          ],
        ),
      ),
      body: child,
    );
  }
}
