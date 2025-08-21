import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../utils/AppColors.dart';

abstract class BaseNavigationWidget extends StatefulWidget {
  const BaseNavigationWidget({Key? key}) : super(key: key);
}

// This is the base class for the navigation component. it has the common functionality for all navigation components.
// like creating a new page controller, handling the current index, and building the navigation bar items.
abstract class BaseNavigationComponentState<T extends BaseNavigationWidget>
    extends State<T> {
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
    final children = getPageViewChildren()
        .map((child) => AutomaticKeepAlive(child: child))
        .toList();

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: children,
      ),
      bottomNavigationBar: SafeArea(
        child: CurvedNavigationBar(
          height: 60,
          backgroundColor: const Color.fromARGB(160, 245, 245, 245),
          color: AppColors.orange,
          items: getNavBarItems(),
          index: _currentIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

// Helper widget for keep-alive
class AutomaticKeepAlive extends StatefulWidget {
  final Widget child;
  const AutomaticKeepAlive({required this.child, Key? key}) : super(key: key);

  @override
  State<AutomaticKeepAlive> createState() => _AutomaticKeepAliveState();
}

class _AutomaticKeepAliveState extends State<AutomaticKeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}