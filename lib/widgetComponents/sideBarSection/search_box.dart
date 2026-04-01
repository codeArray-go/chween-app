import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white12),
      borderRadius: BorderRadius.circular(50),
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: 'Search inside your chat',
          prefixIcon: Icon(Icons.search),
          filled: true,
          fillColor: Colors.white10,
          isDense: true,
          enabledBorder: border,
          focusedBorder: border,
        ),
      ),
    );
  }
}
