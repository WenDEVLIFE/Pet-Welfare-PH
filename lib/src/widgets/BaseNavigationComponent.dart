import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../utils/AppColors.dart';

abstract class BaseNavigationWidget extends StatefulWidget {
  const BaseNavigationWidget({Key? key}) : super(key: key);
}

abstract class BaseNavigationComponentState<T extends BaseNavigationWidget> extends State<T> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  List<Widget> getNavBarItems();
  List<Widget> getPageViewChildren();

  Widget buildNavItem(int index, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontFamily: 'SmoochSans',
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: PageView.builder(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(), 
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      itemCount: getPageViewChildren().length,
      itemBuilder: (context, index) {
        return getPageViewChildren()[index];
      },
    ),
    bottomNavigationBar: SafeArea(
  child: Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: AppColors.orange,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: CurvedNavigationBar(
      height: 60,
      backgroundColor: Colors.transparent,
      color: Colors.transparent, // so container's style is used
      buttonBackgroundColor: Colors.white,
      animationDuration: const Duration(milliseconds: 300),
      animationCurve: Curves.easeOutQuint,
      index: _currentIndex,
      onTap: _onItemTapped,
      items: getNavBarItems()
          .map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: IconTheme(
                data: IconThemeData(
                  size: 28,
                  color: _currentIndex == getNavBarItems().indexOf(item)
                      ? AppColors.orange
                      : Colors.white,
                ),
                child: item,
              ),
            ),
          )
          .toList(),
    ),
  ),
),
  );
}

}