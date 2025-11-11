import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fox_mate_app/presentation/screens/navigation/components/custom_bottom_navigation_bar.dart';
import 'package:fox_mate_app/providers/auth_provider.dart';
import 'package:fox_mate_app/providers/navigation_provider.dart';
import 'package:fox_mate_app/providers/notifications_provider.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeNotifications();
    });
  }

  void _initializeNotifications() {
    final authProvider = context.read<AuthProvider>();
    final notificationsProvider = context.read<NotificationsProvider>();
    final currentUser = authProvider.currentUser;
    
    if (currentUser != null) {
      notificationsProvider.initializeNotifications(currentUser.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        return Scaffold(
          extendBody: false,
          body: IndexedStack(
            index: navigationProvider.currentIndex,
            children: navigationProvider.navigationItems
                .map((item) => item.screen)
                .toList(),
          ),
          bottomNavigationBar: CustomBottomNavigationBar(),
        );
      },
    );
  }
}