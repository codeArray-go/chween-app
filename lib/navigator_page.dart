import 'package:chween_app/pages/global_search_page.dart';
import 'package:chween_app/pages/profile_page.dart';
import 'package:chween_app/pages/setting_page.dart';
import 'package:chween_app/pages/side_bar_page.dart';
import 'package:chween_app/provider/auth_provider.dart';
import 'package:chween_app/widgetComponents/navigator/main_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigatorPage extends ConsumerWidget {
  const NavigatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int pagesIndex = ref.watch(authProvider).selectedIndex;
    final List<dynamic> pages = [SideBarPage(), SettingPage(), GlobalSearchPage(), ProfilePage()];
    return Scaffold(
      body: Stack(
        alignment: AlignmentGeometry.center,
        children: [
          pages[pagesIndex],
          Positioned(bottom: 15, child: MainNavigator()),
        ],
      ),
    );
  }
}
