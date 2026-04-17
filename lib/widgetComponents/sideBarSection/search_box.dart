import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(color: Colors.white10),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: Colors.white38),
          ),
          enabledBorder: border,
          hintText: 'Search in chat',
          hintStyle: const TextStyle(color: Color.fromRGBO(90, 90, 90, 1)),
          prefixIcon: const Icon(Icons.search, size: 25, color: Colors.grey),
          filled: true,
          fillColor: const Color.fromRGBO(7, 7, 7, 1.0),
          isDense: true,
        ),
      ),
    );
  }
}
