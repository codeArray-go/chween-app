import 'package:flutter/material.dart';
import 'package:chween_app/widgetComponents/sideBarSection/profile_header.dart';
import 'package:chween_app/widgetComponents/sideBarSection/search_box.dart';
import 'package:chween_app/widgetComponents/sideBarSection/user_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SideBarPage extends ConsumerWidget {
  const SideBarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeader(),
            SizedBox(height: 15),
            SearchBox(),
            SizedBox(height: 20),
            Expanded(
              child: UserList(),
            ),
          ],
        ),
      ),
    );
  }
}
