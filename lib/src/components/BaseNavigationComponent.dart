import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/AppColors.dart';

abstract class BaseNavigationComponent extends StatefulWidget {
  const BaseNavigationComponent({Key? key}) : super(key: key);
}

abstract class BaseNavigationComponentState<T extends BaseNavigationComponent> extends State<T> {
  final PageController _pageController = PageController(initialPage: 0);
  final List<bool> _isHovering = List<bool>.filled(6, false);
  int _currentIndex = 0;

  List<Widget> getNavBarItems();
  List<Widget> getPageViewChildren();

  Widget buildNavItem(int index, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon),
        Text(label, style: const TextStyle(fontSize: 12,
            fontFamily: 'SmoochSans'
            , fontWeight: FontWeight.w600,
            color: AppColors.white,),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _pageController.jumpToPage(0);
      });
    });
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
      bottomNavigationBar: Stack(
        children: [
          CurvedNavigationBar(
            backgroundColor: const Color.fromARGB(255, 245, 245, 245),
            color: AppColors.orange,
            items: getNavBarItems(),
            index: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
                _pageController.jumpToPage(index);
              });
            },
          ),
        ],
      ),
    );
  }
}