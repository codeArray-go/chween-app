import 'package:chween_app/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatHeader extends ConsumerStatefulWidget {
  const ChatHeader({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends ConsumerState<ChatHeader> {
  late bool isClicked;

  @override
  void initState() {
    super.initState();
    isClicked = false;
  }

  @override
  Widget build(BuildContext context) {
    final chatsProvider = ref.watch(chatProvider);
    final chatsNotifier = ref.read(chatProvider.notifier);
    final userDetail = chatsProvider.selectedUser;
    final socketOnlineIds = chatsProvider.onlineUsers;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
      child: Column(
        children: [
          SafeArea(
            child: Stack(
              children: [
                Row(
                  children: [
                    CircleAvatar(backgroundImage: NetworkImage(userDetail!['profile_pic']), radius: 27),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userDetail['full_name'], style: TextStyle(fontSize: 16)),
                        Text(socketOnlineIds.map((id) => id.toString()).contains(userDetail['id'].toString()) ? 'online' : 'offline', style: TextStyle(fontSize: 11)),
                      ],
                    ),

                    Spacer(),

                    Row(
                      spacing: 20,
                      children: [
                        // SELECTION
                        if (chatsProvider.messageSelected != null)
                          Row(
                            spacing: 15,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  chatsNotifier.unselectedMessageIdToDelete();
                                },
                                child: Icon(Icons.close_rounded),
                              ),
                              // DELETE BUTTON
                              GestureDetector(
                                onTap: () {
                                  chatsNotifier.deleteMessage(chatsProvider.messageSelected as int);
                                  chatsNotifier.unselectedMessageIdToDelete();
                                },
                                child: Icon(Icons.delete_forever, color: Colors.red),
                              ),
                            ],
                          ),

                        GestureDetector(
                          onTapDown: (details) async {
                            final position = details.globalPosition;
                            setState(() {
                              isClicked = true;
                            });

                            await showMenu(
                              menuPadding: EdgeInsets.symmetric(horizontal: 20),
                              shadowColor: Colors.white10,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              context: context,
                              position: RelativeRect.fromLTRB(position.dx, position.dy + 20, 35, 0),
                              items: [
                                PopupMenuItem(child: Row(children: [Icon(Icons.person, size: 18), SizedBox(width: 25), Text('Profile')])),
                                PopupMenuItem(
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
                          },
                          child: Icon(!isClicked ? Icons.more_vert : Icons.close),
                        ),
                      ],
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
