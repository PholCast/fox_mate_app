import 'package:flutter/widgets.dart';

class NavigationItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final Widget screen;
  final String route;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.screen,
    required this.route,
    this.activeIcon,
  });

  factory NavigationItem.create({
    required String label,
    required IconData icon,
    required Widget screen,
    required String route,
    IconData? activeIcon,
  }) {
    return NavigationItem(
      label: label,
      icon: icon,
      screen: screen,
      route: route,
      activeIcon: activeIcon ?? icon,
    );
  }
}