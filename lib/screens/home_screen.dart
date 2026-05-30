import 'package:flutter/material.dart';

import 'home_screen/favourite_page/favourite_page.dart';
import 'home_screen/recent_page/recent_page.dart';
import 'home_screen/setting_page/setting_page.dart';
import 'home_screen/topics_page/topics_page.dart';
import '../utils/platform_util.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const navigationCount = 4;
  final ValueNotifier<int> currentPageNotifier = ValueNotifier<int>(0);
  final PageController pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    pageController.dispose();
    currentPageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final body = PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        itemCount: navigationCount,
        itemBuilder: (_, index) {
          switch (index) {
            case 1:
              return const RecentPage();
            case 2:
              return const FavouritePage();
            case 3:
              return const SettingPage();
            default:
              return const TopicsPage();
          }
        });

    if (isDesktop) {
      return Scaffold(
        body: ValueListenableBuilder(
            valueListenable: currentPageNotifier,
            builder: (context, currentPage, _) {
              return Row(
                children: [
                  NavigationRail(
                    selectedIndex: currentPage,
                    onDestinationSelected: _onNavigationChanged,
                    labelType: NavigationRailLabelType.all,
                    leading: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Icon(
                        Icons.menu_book,
                        size: 32,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.history),
                        label: Text('History'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.favorite),
                        label: Text('Favourite'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings),
                        label: Text('Setting'),
                      ),
                    ],
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: body),
                ],
              );
            }),
      );
    }

    return Scaffold(
      body: body,
      bottomNavigationBar: ValueListenableBuilder(
          valueListenable: currentPageNotifier,
          builder: (context, currentPage, _) {
            return BottomNavigationBar(
              onTap: _onNavigationChanged,
              type: BottomNavigationBarType.fixed,
              currentIndex: currentPage,
              useLegacyColorScheme: false,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  tooltip: 'Home',
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history),
                  tooltip: 'History',
                  label: 'History',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  tooltip: 'Favourite',
                  label: 'Favourite',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  tooltip: 'Setting',
                  label: 'Setting',
                ),
              ],
            );
          }),
    );
  }

  void _onNavigationChanged(int value) {
    if (currentPageNotifier.value == value) return;

    if (isAdjacent(currentPageNotifier.value, value)) {
      pageController.animateToPage(
        value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      pageController.jumpToPage(value);
    }
    currentPageNotifier.value = value;
  }

  bool isAdjacent(int currentPage, int newPage) {
    if (newPage == currentPage + 1 || newPage == currentPage - 1) return true;
    return false;
  }
}
