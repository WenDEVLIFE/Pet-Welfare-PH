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
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: getPageViewChildren(),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color.fromARGB(255, 245, 245, 245),
        color: AppColors.orange,
        items: getNavBarItems(),
        index: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}