import 'package:flutter/material.dart';
import 'package:fox_mate_app/constants/custom_colors.dart';
import 'package:provider/provider.dart';
import 'package:fox_mate_app/presentation/screens/navigation/components/navigation_icon.dart';
import 'package:fox_mate_app/providers/navigation_provider.dart';
import 'package:fox_mate_app/providers/notifications_provider.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<NavigationProvider, NotificationsProvider>(
      builder: (context, navigationProvider, notificationsProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  NavigationIcon(
                    label: 'Inicio',
                    icon: navigationProvider.currentIndex == 0
                        ? const Icon(Icons.home, color: CustomColors.primaryColor, size: 28)
                        : Icon(Icons.home_outlined, color: Colors.grey[600], size: 28),
                    isSelected: navigationProvider.currentIndex == 0,
                    onTap: () => navigationProvider.navigateToIndex(0),
                  ),
                  NavigationIcon(
                    label: 'Parchate',
                    icon: navigationProvider.currentIndex == 1
                        ? const Icon(Icons.celebration, color: CustomColors.primaryColor, size: 28)
                        : Icon(Icons.celebration_outlined, color: Colors.grey[600], size: 28),
                    isSelected: navigationProvider.currentIndex == 1,
                    onTap: () => navigationProvider.navigateToIndex(1),
                  ),
                  NavigationIcon(
                    label: 'Match',
                    icon: navigationProvider.currentIndex == 2
                        ? const Icon(Icons.favorite, color: CustomColors.primaryColor, size: 28)
                        : Icon(Icons.favorite_border, color: Colors.grey[600], size: 28),
                    isSelected: navigationProvider.currentIndex == 2,
                    onTap: () => navigationProvider.navigateToIndex(2),
                  ),
                  NavigationIcon(
                    badgeCount: notificationsProvider.unreadNotificationsCount,
                    label: 'Chats',
                    icon: navigationProvider.currentIndex == 3
                        ? const Icon(Icons.chat_bubble, color: CustomColors.primaryColor, size: 28)
                        : Icon(Icons.chat_bubble_outline, color: Colors.grey[600], size: 28),
                    isSelected: navigationProvider.currentIndex == 3,
                    onTap: () => navigationProvider.navigateToIndex(3),
                  ),
                  NavigationIcon(
                    label: 'Perfil',
                    icon: navigationProvider.currentIndex == 4
                        ? const Icon(Icons.person, color: CustomColors.primaryColor, size: 28)
                        : Icon(Icons.person_outline, color: Colors.grey[600], size: 28),
                    isSelected: navigationProvider.currentIndex == 4,
                    onTap: () => navigationProvider.navigateToIndex(4),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}