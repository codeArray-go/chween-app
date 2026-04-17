import 'package:chween_app/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainNavigator extends ConsumerWidget {
  const MainNavigator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatsProvider = ref.watch(authProvider);
    final chatsNotifier = ref.read(authProvider.notifier);
    final userProfilePic = (ref.watch(authProvider).user as Map<String, dynamic>)['profile_pic'];
    final List<dynamic> icons = [Icons.home, Icons.settings, Icons.search, userProfilePic];

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: const Color(0xFF000000), borderRadius: BorderRadius.circular(50)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(icons.length, (index) {
          final bool isSelected = chatsProvider.selectedIndex == index;
          final item = icons[index];
          return GestureDetector(
            onTap: () {
              chatsNotifier.selectPageIndex(index);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 26, vertical: 12),
              decoration: BoxDecoration(color: isSelected ? const Color(0xFF54a174) : Colors.transparent, borderRadius: BorderRadius.circular(30)),
              child: item is IconData
                  ? Icon(item, size: 25, color: Colors.white)
                  : CircleAvatar(backgroundImage: userProfilePic.toString().isNotEmpty ? NetworkImage(item) : AssetImage("assets/images/default_user.png"), radius: 13),
            ),
          );
        }),
      ),
    );
  }
}
