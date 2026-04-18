import 'package:chween_app/provider/chat_partners_provider.dart';
import 'package:chween_app/widgetComponents/skeletons/user_list.dart';
import 'package:flutter/material.dart';
import 'package:chween_app/widgetComponents/sideBarSection/profile_header.dart';
import 'package:chween_app/widgetComponents/sideBarSection/search_box.dart';
import 'package:chween_app/widgetComponents/sideBarSection/user_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SideBarPage extends ConsumerWidget {
  const SideBarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(chatPartnerProvider).isLoading;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileHeader(),
            const SizedBox(height: 15),
            const SearchBox(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text('Chuyanl', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            SizedBox(height: 10),
            isLoading ? const UserListSkeleton() : const UserList(),
          ],
        ),
      ),
    );
  }
}
