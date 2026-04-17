import 'package:chween_app/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Poppins',
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(surface: Color(0xFF191919), primary: Colors.white, secondary: Colors.grey),

        scaffoldBackgroundColor: const Color(0xFF191919),
        textTheme: TextTheme(titleMedium: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
      ),
      home: const AuthWrapper(),
    );
  }
}
