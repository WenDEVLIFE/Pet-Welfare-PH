import 'package:flutter/cupertino.dart';

class CustomPageViewWidget extends StatelessWidget {
  final PageController controller;
  final ValueChanged<int> onPageChanged;
  final List<Widget> children;

  const CustomPageViewWidget({
    Key? key,
    required this.controller,
    required this.onPageChanged,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller,
      onPageChanged: onPageChanged,
      physics: const NeverScrollableScrollPhysics(),
      children: children, // Disable swipe gesture
    );
  }
}