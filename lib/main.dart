import 'package:chween_app/auth_wrapper.dart';
import 'package:chween_app/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {'/LoginPage': (context) => LoginPage()},
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Poppins',
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(surface: Color(0xFF101010), primary: Colors.white, secondary: Colors.grey),

        scaffoldBackgroundColor: const Color(0xFF101010),
        textTheme: TextTheme(titleMedium: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
      ),
      home: const AuthWrapper(),
    );
  }
}
