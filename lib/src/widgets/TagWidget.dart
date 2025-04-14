import 'package:flutter/material.dart';
import 'package:pet_welfrare_ph/src/utils/AppColors.dart';
import 'package:pet_welfrare_ph/src/widgets/CustomText.dart';

class TagsInputWidget extends StatelessWidget {
  final TextEditingController tagController;
  final List<String> tags;
  final Function(String) onAddTag;
  final Function(String) onRemoveTag;
  final double screenHeight;

  const TagsInputWidget({
    Key? key,
    required this.tagController,
    required this.tags,
    required this.onAddTag,
    required this.onRemoveTag,
    required this.screenHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: tagController,
          decoration: InputDecoration(
            labelText: 'Enter a tag',
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => onAddTag(tagController.text.trim()),
            ),
          ),
          onSubmitted: (value) => onAddTag(value.trim()),
        ),
        const SizedBox(height: 10),
        CustomText(
          text: 'Your Tags',
          size: 16,
          color: AppColors.black,
          weight: FontWeight.w600,
          align: TextAlign.start,
          screenHeight: screenHeight,
          alignment: Alignment.centerLeft,
        ),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: tags.map((tag) {
            return Chip(
              label: Text(tag),
              deleteIcon: const Icon(Icons.close),
              onDeleted: () => onRemoveTag(tag),
            );
          }).toList(),
        ),
      ],
    );
  }
}