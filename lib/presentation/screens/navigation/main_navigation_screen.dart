import 'package:flutter/material.dart';
import 'package:fox_mate_app/presentation/screens/home/post_screen.dart';
import 'package:provider/provider.dart';
import 'package:fox_mate_app/presentation/screens/navigation/components/custom_bottom_navigation_bar.dart';
import 'package:fox_mate_app/providers/navigation_provider.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        return Scaffold(
          extendBody: true,
          body: IndexedStack(
            index: navigationProvider.currentIndex,
            children:
                navigationProvider.navigationItems
                    .map((item) => item.screen)
                    .toList(),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostScreen()),
              );
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: const CircleBorder(),
            child: const Icon(Icons.add, size: 28, color: Colors.white),
          ),

          bottomNavigationBar: CustomBottomNavigationBar(),
        );
      },
    );
  }
}