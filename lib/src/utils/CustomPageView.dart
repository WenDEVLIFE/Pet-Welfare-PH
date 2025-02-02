import 'package:flutter/cupertino.dart';

class CustomPageView extends StatelessWidget {
  final PageController controller;
  final ValueChanged<int> onPageChanged;
  final List<Widget> children;

  const CustomPageView({
    required this.controller,
    required this.onPageChanged,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      onPageChanged: onPageChanged,
      itemCount: children.length,
      itemBuilder: (context, index) {
        return children[index];
      },
      physics: const NeverScrollableScrollPhysics(), // Disable swipe gesture
    );
  }
}