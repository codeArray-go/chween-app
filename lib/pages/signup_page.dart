// import 'package:chween_app/widgetComponents/input_box.dart';
// import 'package:flutter/material.dart';
//
// class SignupPage extends StatelessWidget {
//   const SignupPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final Color cardBackground = const Color(0xFF262626);
//     final Color fieldBackground = Colors.black;
//
//     return Scaffold(
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           child: Container(
//             decoration: BoxDecoration(
//               color: cardBackground,
//               borderRadius: BorderRadius.circular(15),
//               border: BoxBorder.all(color: Colors.white10),
//             ),
//             height: 700,
//             padding: EdgeInsets.symmetric(vertical: 20),
//             width: double.infinity,
//             child: Column(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white10,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.white10),
//                   ),
//                   padding: const EdgeInsets.all(10),
//                   child: const Icon(Icons.messenger_outline_rounded),
//                 ),
//                 SizedBox(height: 10),
//                 Text('Create your account', style: Theme.of(context).textTheme.titleMedium),
//                 const SizedBox(height: 10),
//                 const Text('It will take a few seconds', style: TextStyle(color: Colors.white54)),
//                 const SizedBox(height: 10),
//
//                 // Input Boxes
//                 Padding(
//                   padding: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 20),
//                   child: Column(
//                     spacing: 8,
//                     children: [
//                       // Full name box
//                       InputBox(labelText: 'Full name', bgColor: fieldBackground, hintText: 'Cobra', icon: Icon(Icons.person)),
//
//                       // Email Input Box
//                       InputBox(labelText: 'Email', bgColor: fieldBackground, hintText: 'testgmail123@gmail.com', icon: Icon(Icons.email_outlined)),
//
//                       // Password input box
//                       InputBox(labelText: 'Password', bgColor: fieldBackground, hintText: '********', icon: Icon(Icons.lock)),
//
//                       // Confirm Password input box
//                       InputBox(labelText: 'Confirm Password', bgColor: fieldBackground, hintText: '********', icon: Icon(Icons.lock)),
//                     ],
//                   ),
//                 ),
//
//                 //   Submit Button
//                 ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.symmetric(vertical: 13),
//                     backgroundColor: Colors.white,
//                     minimumSize: Size(270, 40),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                   ),
//                   child: const Text('Submit', style: TextStyle(color: Colors.black)),
//                 ),
//
//                 //   Login Option
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text('Already have account ?'),
//                     TextButton(
//                       onPressed: () {},
//                       child: const Text('Sign in', style: TextStyle(color: Colors.blue)),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // Reusable Input box
