
import 'package:flutter/cupertino.dart';

class CustomPageViewWidget extends StatelessWidget {
  final PageController controller;
  final ValueChanged<int> onPageChanged;
  final List<Widget> children;

  const CustomPageViewWidget({Key? key,
    required this.controller,
    required this.onPageChanged,
    required this.children,
  }) : super(key: key);

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