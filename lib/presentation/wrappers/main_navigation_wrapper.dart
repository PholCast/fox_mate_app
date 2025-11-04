import 'package:flutter/material.dart';
import 'package:fox_mate_app/constants/custom_colors.dart';
import 'package:fox_mate_app/presentation/screens/home/post_screen.dart';
import 'package:fox_mate_app/presentation/screens/home/events_screen.dart';
import 'package:fox_mate_app/presentation/screens/match/match_screen.dart';
import 'package:fox_mate_app/presentation/screens/chat/chats.screen.dart';
import 'package:fox_mate_app/presentation/screens/profile/profile_screen.dart';

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _currentIndex = 0;

  // Lista de pantallas
  final List<Widget> _screens = [
    PostScreen(),
    EventsScreen(),
    MatchScreen(),
    ChatsScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, 'Inicio', 0),
              _buildNavItem(Icons.celebration_outlined, 'Parchate', 1),
              _buildNavItem(Icons.favorite_border, 'Match', 2),
              _buildNavItem(Icons.chat_bubble_outline, 'Chats', 3),
              _buildNavItem(Icons.person_outline, 'Perfil', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? CustomColors.primaryColor : Colors.grey[600],
              size: 26,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? CustomColors.primaryColor : Colors.grey[600],
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}