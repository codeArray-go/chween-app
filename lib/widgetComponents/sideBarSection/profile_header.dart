import 'package:chween_app/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileHeader extends ConsumerStatefulWidget {
  const ProfileHeader({super.key});

  @override
  ConsumerState<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends ConsumerState<ProfileHeader> {
  late bool isClicked;

  @override
  void initState() {
    super.initState();
    isClicked = false;
  }

  @override
  Widget build(BuildContext context) {
    final authUser = ref.watch(authProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        children: [
          SafeArea(
            child: Stack(
              children: [
                Row(
                  children: [
                    CircleAvatar(backgroundImage: NetworkImage('${authUser.user?['profile_pic']}'), radius: 33),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text("${authUser.user?['full_name']}", style: TextStyle(fontSize: 17))],
                    ),

                    Spacer(),

                    GestureDetector(
                      onTapDown: (details) async {
                        final position = details.globalPosition;
                        setState(() {
                          isClicked = true;
                        });

                        final navigator = Navigator.of(context);

                        final selected = await showMenu(
                          menuPadding: EdgeInsets.symmetric(horizontal: 20),
                          shadowColor: Colors.white10,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          context: context,
                          position: RelativeRect.fromLTRB(
                            position.dx,
                            position.dy + 20, // push down down
                            35,
                            0,
                          ),
                          items: [
                            PopupMenuItem(
                              value: 'profile',
                              child: Row(children: [Icon(Icons.person, size: 18), SizedBox(width: 25), Text('Profile')]),
                            ),
                            PopupMenuItem(
                              value: 'logout',
                              child: Row(
                                children: [
                                  Icon(Icons.logout, size: 18, color: Colors.red),
                                  SizedBox(width: 25),
                                  Text('Logout', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                        );
                        setState(() {
                          isClicked = false;
                        });
                        if (selected == 'logout') {
                          await ref.read(authProvider.notifier).logout();
                          if (!mounted) return;
                          navigator.pushReplacementNamed('/LoginPage');
                        }
                      },
                      child: Icon(!isClicked ? Icons.more_vert : Icons.close),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
