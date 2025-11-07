import 'package:flutter/material.dart';
import 'package:fox_mate_app/domain/entities/navigation_item.dart';
import 'package:fox_mate_app/domain/repositories/navigation_repository.dart';
import 'package:fox_mate_app/presentation/screens/chat/chats_screen.dart';
import 'package:fox_mate_app/presentation/screens/home/events_screen.dart';
import 'package:fox_mate_app/presentation/screens/home/post_screen.dart';
import 'package:fox_mate_app/presentation/screens/match/match_screen.dart';
import 'package:fox_mate_app/presentation/screens/profile/profile_screen.dart';

class NavigationRepositoryImpl implements NavigationRepository {

  static final List<NavigationItem> _navigationItems = [
    NavigationItem.create(
      label: 'Posts',
      icon: Icons.home,
      screen: PostScreen(),
      route: '/posts'
    ),
    NavigationItem.create(
      label: 'Events',
      icon: Icons.bookmark,
      screen: EventsScreen(),
      route: '/events',
    ),
    NavigationItem.create(
      label: 'Match',
      icon: Icons.notifications,
      screen: MatchScreen(),
      route: '/match',
    ),
    NavigationItem.create(
      label: 'Chats',
      icon: Icons.person,
      screen: ChatsScreen(),
      route: '/chats',
    ),
    NavigationItem.create(
      label: 'Profile',
      icon: Icons.person,
      screen: ProfileScreen(),
      route: '/profile',
    ),
  ];

  @override
  NavigationItem? getNavigationItemByIndex(int index) {
    if(index > 0 && index < _navigationItems.length) {
      return _navigationItems[index];
    }
    return null;
  }

  @override
  NavigationItem? getNavigationItemByRoute(String route) {
    return _navigationItems.firstWhere((element) => element.route == route);
  }

  @override
  List<NavigationItem> getNavigationItems() {
    return _navigationItems;
  }

  @override
  int getNavigationItemsCount() {
    return _navigationItems.length;
  }
  
}