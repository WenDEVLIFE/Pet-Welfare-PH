import 'package:flutter/material.dart';

class MapSearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onSearch;
  final VoidCallback onClear;
  final String hintText;

  const MapSearchTextField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.onSearch,
    required this.onClear,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.99,
      height: screenHeight * 0.08,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.transparent, width: 7),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onSearch, // Calls function when text changes
        decoration: InputDecoration(
          filled: true,
          prefixIcon: const Icon(Icons.search, color: Colors.black),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear, color: Colors.black),
            onPressed: onClear, // Calls function when clear button is pressed
          )
              : null,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.transparent, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.orange, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.orange, width: 2),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.black,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
        ),
        style: const TextStyle(
          fontFamily: 'LeagueSpartan',
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
