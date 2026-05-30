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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/icons/pitaka_sarupa.png',
                          width: 48,
                          height: 48,
                          errorBuilder: (_, _, _) => Icon(
                            Icons.menu_book,
                            size: 32,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
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
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeIn,
                      switchOutCurve: Curves.easeOut,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                      child: KeyedSubtree(
                        key: ValueKey<int>(currentPage),
                        child: _pageWidget(currentPage),
                      ),
                    ),
                  ),
                ],
              );
            }),
      );
    }

    return Scaffold(
      body: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          itemCount: navigationCount,
          itemBuilder: (_, index) => _pageWidget(index)),
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

  Widget _pageWidget(int index) {
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
  }

  void _onNavigationChanged(int value) {
    final previous = currentPageNotifier.value;
    if (previous == value) return;
    currentPageNotifier.value = value;

    if (!isDesktop) {
      if ((value - previous).abs() == 1) {
        pageController.animateToPage(
          value,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      } else {
        pageController.jumpToPage(value);
      }
    }
  }
}
