import 'package:flutter/material.dart';
import 'package:chween_app/widgetComponents/sideBarSection/profile_header.dart';
import 'package:chween_app/widgetComponents/sideBarSection/search_box.dart';
import 'package:chween_app/widgetComponents/sideBarSection/user_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SideBarPage extends ConsumerWidget {
  const SideBarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeader(),
          Container(
            decoration: BoxDecoration(
              border: BoxBorder.symmetric(horizontal: BorderSide(color: Color.fromRGBO(255, 255, 255, 0.05))),
            ),
          ),
          SizedBox(height: 20),
          SearchBox(),
          SizedBox(height: 30),
          Expanded(child: UserList()),
        ],
      ),
    );
  }
}
