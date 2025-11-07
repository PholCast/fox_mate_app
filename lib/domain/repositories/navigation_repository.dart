import 'package:fox_mate_app/domain/entities/navigation_item.dart';

abstract class NavigationRepository {

  List<NavigationItem> getNavigationItems();

  NavigationItem? getNavigationItemByIndex(int index);

  NavigationItem? getNavigationItemByRoute(String route);

  int getNavigationItemsCount();
} 