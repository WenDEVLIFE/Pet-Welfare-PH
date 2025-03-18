import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReactionUtils {
  static IconData getReactionIcon(String reaction) {
    switch (reaction) {
      case 'like':
        return Icons.thumb_up;
      case 'heart':
        return Icons.favorite;
      case 'HAHA':
        return Icons.emoji_emotions;
      case 'angry':
        return Icons.sentiment_very_dissatisfied_sharp;
      case 'sad':
        return Icons.sentiment_dissatisfied;
      default:
        return Icons.thumb_up_outlined;
    }
  }

  static Color getReactionColor(String reaction) {
    switch (reaction) {
      case 'like':
        return Colors.blue;
      case 'heart':
        return Colors.red;
      case 'HAHA':
        return Colors.yellow;
      case 'angry':
        return Colors.red;
      case 'sad':
        return Colors.white;
      default:
        return Colors.black;
    }
  }
}