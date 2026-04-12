import 'package:chween_app/lib/flutter_secure_storage.dart';
import 'package:chween_app/provider/auth_provider.dart';
import 'package:chween_app/widgetComponents/input_box.dart';
import 'package:chween_app/widgetComponents/orbit_dot_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color cardBackground = const Color(0xFF262626);
    final Color fieldBackground = Colors.black;
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            decoration: BoxDecoration(
              color: cardBackground,
              borderRadius: BorderRadius.circular(15),
              border: BoxBorder.all(color: Colors.white10),
            ),
            height: 500,
            padding: EdgeInsets.symmetric(vertical: 20),
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white10),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.messenger_outline_rounded),
                ),
                SizedBox(height: 10),
                Text('Welcome back', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                const Text('Sign in to continue your secure chats', style: TextStyle(color: Colors.white54)),
                const SizedBox(height: 10),

                // Input Boxes
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 20),
                  child: Column(
                    spacing: 8,
                    children: [
                      // Email input box
                      InputBox(textController: emailController, labelText: 'Email', bgColor: fieldBackground, hintText: 'example123@gmail.com', icon: Icon(Icons.email_outlined)),

                      // Password input box
                      InputBox(textController: passwordController, labelText: 'Password', bgColor: fieldBackground, hintText: '********', icon: Icon(Icons.lock)),
                    ],
                  ),
                ),

                //   Submit Button
                ElevatedButton(
                  onPressed: () {
                    ref.read(authProvider.notifier).login(emailController.text, passwordController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.black,
                    elevation: 5,
                    overlayColor: const Color(0xFF000000),
                    padding: EdgeInsets.symmetric(vertical: 13),
                    backgroundColor: Colors.white,
                    minimumSize: Size(270, 40),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: authState.isLoading ? OrbitDotLoader() : Text("Submit", style: TextStyle(color: Colors.black)),
                ),

                //   Login Option
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have account ?'),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Create one', style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Reusable Input box
