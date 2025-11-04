import 'package:flutter/material.dart';
import 'package:fox_mate_app/constants/custom_colors.dart';
import 'package:provider/provider.dart';
import 'package:fox_mate_app/presentation/screens/navigation/components/navigation_icon.dart';
import 'package:fox_mate_app/providers/navigation_provider.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        return BottomAppBar(
          color: Colors.white,
          notchMargin: 10,
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavigationIcon(
                icon:
                    navigationProvider.currentIndex == 0
                        ? Icon(Icons.home,color: CustomColors.primaryColor)
                        : Icon(Icons.home_outlined,color: Colors.grey[600]),
                onTap: () => navigationProvider.navigateToIndex(0),
              ),
              NavigationIcon(
                icon:
                    navigationProvider.currentIndex == 1
                        ? Icon(Icons.celebration,color: CustomColors.primaryColor)
                        : Icon(Icons.celebration_outlined,color: Colors.grey[600]),
                onTap: () => navigationProvider.navigateToIndex(1),
              ),
              SizedBox(width: 40,),
              NavigationIcon(
                icon:
                    navigationProvider.currentIndex == 2
                        ? Icon(Icons.favorite,color: CustomColors.primaryColor)
                        : Icon(Icons.favorite_border,color: Colors.grey[600]),
                onTap: () => navigationProvider.navigateToIndex(2),
              ),
              NavigationIcon(
                icon:
                    navigationProvider.currentIndex == 3
                        ? Icon(Icons.chat_bubble,color: CustomColors.primaryColor)
                        : Icon(Icons.chat_bubble_outline,color: Colors.grey[600]),
                onTap: () => navigationProvider.navigateToIndex(3),
              ),
              NavigationIcon(
                icon:
                    navigationProvider.currentIndex == 4
                        ? Icon(Icons.person,color: CustomColors.primaryColor)
                        : Icon(Icons.person_outline,color: Colors.grey[600]),
                onTap: () => navigationProvider.navigateToIndex(4),
              ),
            ],
          ),
        );
      },
    );
  }
}
