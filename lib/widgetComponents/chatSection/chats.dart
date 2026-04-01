import 'package:chween_app/provider/auth_provider.dart';
import 'package:chween_app/provider/chat_provider.dart';
import 'package:chween_app/widgetComponents/chatSection/chat_input_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class Chats extends ConsumerWidget {
  const Chats({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUserId = (ref.watch(authProvider)).user?['id'];
    final chatsProvider = ref.watch(chatProvider);
    final chatsNotifier = ref.read(chatProvider.notifier);

    return Container(
      color: const Color(0xFF171717),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: chatsProvider.chats.length,
              itemBuilder: (context, index) {
                final chat = chatsProvider.chats[index];
                final isSender = chat['sender_id'] == authUserId;

                final rawTime = chat['created_at'] as String;
                final messageCreatedTime = DateFormat('h:mm a').format(DateTime.parse(rawTime).toLocal());
                return GestureDetector(
                  onLongPress: () {
                    chatsNotifier.messageIdToDelete(int.parse(chat['id']));
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    padding: EdgeInsets.symmetric(horizontal: 13),
                    decoration: BoxDecoration(color: chatsProvider.messageSelected == int.parse(chat['id']) ? const Color.fromRGBO(255, 255, 255, 0.07) : Color.fromRGBO(0, 0, 0, 0)),
                    child: _chatBubble(message: chat['text'] as String, isSender: isSender, imgUrl: chat['image'] as String?, time: messageCreatedTime),
                  ),
                );
              },
            ),
          ),
          ChatInputBox(),
        ],
      ),
    );
  }
}

Widget _chatBubble({required String message, required bool isSender, required String? imgUrl, required String time}) {
  final borderRadiusCircular = const Radius.circular(10);

  return Align(
    alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      constraints: const BoxConstraints(maxWidth: 280),
      decoration: BoxDecoration(
        color: isSender ? const Color(0xFF1C2B4A) : const Color(0xFF333333),
        borderRadius: BorderRadius.only(
          topLeft: borderRadiusCircular,
          topRight: borderRadiusCircular,
          bottomLeft: isSender ? borderRadiusCircular : const Radius.circular(0),
          bottomRight: isSender ? const Radius.circular(0) : borderRadiusCircular,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (imgUrl != null && imgUrl.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(bottom: message.isNotEmpty ? 8 : 0),
                    child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(imgUrl)),
                  ),
                if (message.isNotEmpty) Text(message, style: const TextStyle(color: Colors.white, fontSize: 14)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(time, style: const TextStyle(color: Colors.white54, fontSize: 10)),
          ),
        ],
      ),
    ),
  );
}
