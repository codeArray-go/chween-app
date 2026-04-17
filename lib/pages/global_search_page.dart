import 'package:flutter/material.dart';

class GlobalSearchPage extends StatelessWidget {
  const GlobalSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(color: Colors.white10),
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("Search", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.white38),
                  ),
                  enabledBorder: border,
                  hintText: 'Search with user name',
                  hintStyle: const TextStyle(color: Color.fromRGBO(90, 90, 90, 1)),
                  prefixIcon: const Icon(Icons.search, size: 28, color: Colors.grey),
                  filled: true,
                  fillColor: const Color.fromRGBO(7, 7, 7, 1.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
