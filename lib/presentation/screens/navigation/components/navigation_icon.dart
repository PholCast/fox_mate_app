import 'package:flutter/material.dart';
import 'package:fox_mate_app/constants/custom_colors.dart';

class NavigationIcon extends StatelessWidget {
  const NavigationIcon({
    Key? key,
    required this.icon,
    required this.onTap,
    required this.label,
    this.badgeCount = 0,
    this.isSelected = false, // 👈 nueva propiedad
  }) : super(key: key);

  final Icon icon;
  final VoidCallback onTap;
  final int badgeCount;
  final String label;
  final bool isSelected; // 👈 indica si está activo

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                child: icon,
              ),
              if (badgeCount > 0)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      maxWidth: 16,
                      maxHeight: 16,
                    ),
                    child: Center(
                      child: Text(
                        badgeCount > 99 ? '99+' : badgeCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected
                  ? CustomColors.primaryColor
                  : Colors.grey[600],
              fontWeight: isSelected
                  ? FontWeight.w600
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
