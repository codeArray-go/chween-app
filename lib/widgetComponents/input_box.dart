import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  final String labelText;
  final Color bgColor;
  final String hintText;
  final Icon icon;
  final TextEditingController textController;

  const InputBox({super.key, required this.labelText, required this.bgColor, required this.hintText, required this.icon, required this.textController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        TextField(
          style: TextStyle(fontSize: 13),
          controller: textController,
          cursorColor: Colors.white,
          decoration: InputDecoration(
            filled: true,
            isDense: true,
            fillColor: bgColor,
            prefixIcon: icon,
            prefixIconColor: Colors.white54,
            hint: Text(hintText, style: TextStyle(color: Colors.white38)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.white24),
            ),
          ),
        ),
      ],
    );
  }
}
