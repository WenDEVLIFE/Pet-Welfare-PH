import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpandableTags extends StatefulWidget {
  final List<String> tags;
  final int maxVisibleTags;

  const ExpandableTags({
    Key? key,
    required this.tags,
    this.maxVisibleTags = 3, // Default to showing 3 tags when collapsed
  }) : super(key: key);

  @override
  _ExpandableTagsState createState() => _ExpandableTagsState();
}

class _ExpandableTagsState extends State<ExpandableTags> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final visibleTags = isExpanded
        ? widget.tags
        : widget.tags.take(widget.maxVisibleTags).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: visibleTags.map((tag) {
            return Chip(
              label: Text(tag),
            );
          }).toList(),
        ),
        if (widget.tags.length > widget.maxVisibleTags)
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Text(
              isExpanded ? 'See Less' : 'See More',
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}