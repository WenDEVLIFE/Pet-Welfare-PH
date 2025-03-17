import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';

class ReactionModal extends StatefulWidget {
  final Function(String) onReactionSelected;

  ReactionModal({required this.onReactionSelected});

  @override
  _ReactionModalState createState() => _ReactionModalState();
}

class _ReactionModalState extends State<ReactionModal> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.orange,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select a reaction',
              style: const TextStyle(
                fontFamily: 'SmoochSans',
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildReactionButton(Icons.thumb_up, 'like', Colors.blue, 'Like', sizes: 50.0),
                _buildReactionButton(Icons.favorite, 'heart', Colors.red, 'Heart', sizes: 50.0),
                _buildReactionButton(Icons.sentiment_very_dissatisfied_sharp, 'angry', Colors.red, 'Angry', sizes: 50.0),
                _buildReactionButton(Icons.sentiment_dissatisfied, 'sad', Colors.white, 'Sad', sizes: 50.0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReactionButton(IconData icon, String reaction, Color color, String label, {required double sizes}) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: color, size: sizes),
          onPressed: () {
            widget.onReactionSelected(reaction);
            Navigator.pop(context);
          },
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'SmoochSans',
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}