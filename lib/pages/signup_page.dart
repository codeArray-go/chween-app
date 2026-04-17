import 'package:chween_app/auth_wrapper.dart';
import 'package:chween_app/provider/auth_provider.dart';
import 'package:chween_app/widgetComponents/input_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color cardBackground = const Color(0xFF262626);
    final Color fieldBackground = Colors.black;

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
            height: 700,
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
                Text('Create your account', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                const Text('It will take a few seconds', style: TextStyle(color: Colors.white54)),
                const SizedBox(height: 10),

                // Input Boxes
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 20),
                  child: Column(
                    spacing: 8,
                    children: [
                      // Full name box
                      InputBox(textController: fullNameController, labelText: 'Full name', bgColor: fieldBackground, hintText: 'Cobra', icon: Icon(Icons.person)),

                      // Email Input Box
                      InputBox(textController: emailController, labelText: 'Email', bgColor: fieldBackground, hintText: 'testgmail123@gmail.com', icon: Icon(Icons.email_outlined)),

                      // Password input box
                      InputBox(textController: passwordController, labelText: 'Password', bgColor: fieldBackground, hintText: '********', icon: Icon(Icons.lock)),

                      // Confirm Password input box
                      InputBox(textController: confirmPasswordController, labelText: 'Confirm Password', bgColor: fieldBackground, hintText: '********', icon: Icon(Icons.lock)),
                    ],
                  ),
                ),

                //   Submit Button
                ElevatedButton(
                  onPressed: () {
                    ref.read(authProvider.notifier).signUp(fullNameController.text, emailController.text, passwordController.text);
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const AuthWrapper()), (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 13),
                    backgroundColor: Colors.white,
                    minimumSize: Size(270, 40),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Submit', style: TextStyle(color: Colors.black)),
                ),

                //   Login Option
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have account ?'),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Sign in', style: TextStyle(color: Colors.blue)),
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
