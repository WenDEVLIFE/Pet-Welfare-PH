import 'package:flutter/material.dart';

class EditTagWidget extends StatelessWidget {
  final TextEditingController tagController;
  final List<String> tags;
  final Function(String) onAddTag;
  final Function(String) onRemoveTag;
  final Function(String) onSelectTag;
  final double screenHeight;
  final String? selectedTag;

  const EditTagWidget({
    Key? key,
    required this.tagController,
    required this.tags,
    required this.onAddTag,
    required this.onRemoveTag,
    required this.onSelectTag,
    required this.screenHeight,
    this.selectedTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TextField for adding tags
        TextField(
          controller: tagController,
          decoration: InputDecoration(
            labelText: 'Enter a tag',
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                if (tagController.text.trim().isNotEmpty) {
                  onAddTag(tagController.text.trim());
                  tagController.clear();
                }
              },
            ),
          ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              onAddTag(value.trim());
              tagController.clear();
            }
          },
        ),
        const SizedBox(height: 10),
        // Title for tags
        Text(
          'Your Tags',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        // Display tags as chips
        Wrap(
          spacing: 8.0,
          children: tags.map((tag) {
            final isSelected = tag == selectedTag;
            return GestureDetector(
              onTap: () => onSelectTag(tag),
              child: Chip(
                label: Text(tag),
                backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
                deleteIcon: Icon(Icons.close, color: isSelected ? Colors.white : Colors.black),
                onDeleted: () => onRemoveTag(tag),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}