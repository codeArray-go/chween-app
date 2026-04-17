import 'package:chween_app/pages/chat_container.dart';
import 'package:chween_app/provider/chat_partners_provider.dart';
import 'package:chween_app/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserList extends ConsumerWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(chatPartnerProvider);
    final partners = users.partners ?? [];
    final chatsProvider = ref.watch(chatProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Chunyal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 0),
              scrollDirection: Axis.vertical,
              itemCount: partners.length,
              itemBuilder: (context, index) {
                final user = partners[index];
                final notifications = chatsProvider.notificationCount;
                final onlineUserId = chatsProvider.onlineUsers.firstWhere((onlineUserId) => onlineUserId.contains(user['id']), orElse: () => "0");

                final notification = notifications.firstWhere((n) => n['sender_id'].toString() == user['id'], orElse: () => null);
                final isTyping = chatsProvider.typingUsers[user['id'].toString()];

                return GestureDetector(
                  onTap: () async {
                    final chatNotifier = ref.read(chatProvider.notifier);
                    final id = int.parse(user['id']);

                    chatNotifier.setSelectedUser(id, user['full_name'], user['profile_pic']);
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ChatContainer();
                        },
                      ),
                    );

                    chatNotifier.clearSelectedUser();
                  },
                  child: _user(
                    imgSrc: user['profile_pic'] as String,
                    name: user['full_name'] as String,
                    lastMsg: user['text'] as String,
                    senderAsMe: user['is_me'] as bool,
                    notificationCount: notification?['unread_count'],
                    isOnline: (int.parse(onlineUserId) > 0) ? true : false,
                    isTyping: (isTyping != null) ? isTyping : false,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _user({required String imgSrc, required String name, required String lastMsg, required bool senderAsMe, required notificationCount, required bool isOnline, required bool isTyping}) {
  List<String> lstMsg = lastMsg.split(' ');
  final onlineOfflineColor = isOnline ? 0xFF0FB300 : 0xFF6C6C6C;

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
    child: Row(
      spacing: 20,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(backgroundImage: imgSrc != "" ? NetworkImage(imgSrc) : const AssetImage("assets/images/default_user.png"), radius: 30),
            Positioned(
              top: -1,
              right: -2,
              child: Container(
                decoration: BoxDecoration(color: Color(onlineOfflineColor), borderRadius: BorderRadius.circular(50)),
                width: 10,
                height: 10,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            SizedBox(),
            (isTyping)
                ? Text('typing...', style: TextStyle(color: const Color(0xFF0FB300)))
                : Row(
                    spacing: 3,
                    children: [
                      Text(
                        senderAsMe ? 'sent: ' : 'received:',
                        style: TextStyle(fontSize: 13, color: Colors.white38, fontWeight: FontWeight.w600),
                      ),
                      Text(lstMsg.length <= 3 ? lastMsg : "${lstMsg.take(3).join(' ')}...", style: TextStyle(fontSize: 13, color: Colors.white54)),
                    ],
                  ),
          ],
        ),
        Spacer(),
        if (notificationCount != null && notificationCount != "0")
          Container(
            height: 23,
            width: 23,
            decoration: BoxDecoration(
              border: BoxBorder.all(color: Color(onlineOfflineColor)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                textAlign: TextAlign.center,
                notificationCount,
                style: TextStyle(color: Color(onlineOfflineColor), fontWeight: FontWeight.w500),
              ),
            ),
          ),
      ],
    ),
  );
}
