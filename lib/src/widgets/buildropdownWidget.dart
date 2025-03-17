
import 'package:flutter/material.dart';

import '../utils/AppColors.dart';

Widget buildDropdown<T>({
  required T? value,
  required String hint,
  required List<T> items,
  required ValueChanged<T?> onChanged,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: AppColors.gray,
      border: Border.all(color: AppColors.gray, width: 2),
      borderRadius: BorderRadius.circular(10),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        value: items.contains(value) ? value : null,
        hint: Text(hint),
        items: items.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(
              item.toString(), // Ensure this returns a readable string
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'SmoochSans',
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        dropdownColor: AppColors.gray,
        iconEnabledColor: Colors.grey,
        isExpanded: true,
      ),
    ),
  );
}
