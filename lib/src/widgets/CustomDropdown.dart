import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDropDown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String Function(T) itemLabel;
  final String hint;

  const CustomDropDown({
    required this.value,
    required this.items,
    required this.onChanged,
    required this.itemLabel,
    required this.hint,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            hint: Text(hint),
            value: value,
            items: items.map<DropdownMenuItem<T>>((T value) {
              return DropdownMenuItem<T>(
                value: value,
                child: Text(
                  itemLabel(value),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            dropdownColor: Colors.grey[200],
            iconEnabledColor: Colors.grey,
            isExpanded: true,
          ),
        ),
      ),
    );
  }
}