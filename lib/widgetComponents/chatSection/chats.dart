import 'dart:io';

import 'package:chween_app/manager/socket_manager.dart';
import 'package:chween_app/provider/auth_provider.dart';
import 'package:chween_app/provider/chat_provider.dart';
import 'package:chween_app/widgetComponents/chatSection/chat_bubble_paint.dart';
import 'package:chween_app/widgetComponents/chatSection/chat_input_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class Chats extends HookConsumerWidget {
  const Chats({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      ref.read(chatProvider.notifier).emitSeenStatus();

      final manager = ref.read(socketManagerProvider);
      manager.subscribeToChat();

      return () {
        manager.unSubscribeToChat();
      };
    }, []);

    ref.listen(chatProvider.select((state) => state.chats), (previous, next) {
      if (next.length > ((previous ?? []).length)) {
        final lastMessage = next.last;

        if (lastMessage['sender_id'] != ref.watch(chatProvider).selectedUser?['id']) {
          ref.read(chatProvider.notifier).emitSeenStatus();
        }
      }
    });

    final authUserId = ref.watch(authProvider).user?['id'];
    final chatsProvider = ref.watch(chatProvider);
    final chatsNotifier = ref.read(chatProvider.notifier);
    final isTyping = chatsProvider.typingUsers[chatsProvider.selectedUser?['id'].toString()];

    final userMessages = chatsProvider.chats.where((m) => m["sender_id"] == authUserId);
    final lastUserMsgId = userMessages.isNotEmpty ? userMessages.last['id'].toString() : null;

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

                String messageCreatedTime = "0:00";
                try {
                  final rawTime = chat['created_at'] as String;
                  messageCreatedTime = DateFormat('h:mm a').format(DateTime.parse(rawTime).toLocal());
                } catch (e) {
                  debugPrint("Time parse error: $e");
                }

                final msgId = chat['id'].toString();

                return Column(
                  children: [
                    GestureDetector(
                      onLongPress: () => chatsNotifier.messageIdToDelete(int.parse(msgId)),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 3),
                        padding: const EdgeInsets.symmetric(horizontal: 13),
                        decoration: BoxDecoration(color: chatsProvider.messageSelected == int.parse(msgId) ? const Color.fromRGBO(255, 255, 255, 0.07) : Colors.transparent),

                        child: _chatBubble(
                          msgSeen: chat['is_seen'] == true,
                          msgId: msgId,
                          message: (chat['text'] ?? "") as String,
                          isSender: isSender,
                          imgUrl: chat['image'] as String?,
                          time: messageCreatedTime,
                          lastMessageSenderId: lastUserMsgId ?? "",
                          isOptimisticMessage: chat['isOptimisticMessage'] == true,
                        ),
                      ),
                    ),
                    if (isTyping != null && lastUserMsgId == msgId) Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: _typingBubble(isSender: false)),
                  ],
                );
              },
            ),
          ),
          const ChatInputBox(),
        ],
      ),
    );
  }
}

Widget _chatBubble({
  required bool msgSeen,
  required String msgId,
  required String message,
  required bool isSender,
  required String? imgUrl,
  required String time,
  required String lastMessageSenderId,
  required bool isOptimisticMessage,
}) {
  final isImage = imgUrl != null && imgUrl.isNotEmpty;

  return Align(
    alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomPaint(
          painter: ChatBubblePaint(color: isSender ? const Color(0xFF1C2B4A) : const Color(0xFF333333), isSender: isSender),
          child: Container(
            padding: EdgeInsets.all(8),
            constraints: const BoxConstraints(maxWidth: 280),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isImage) ...[
                        ClipRRect(borderRadius: BorderRadius.circular(8), child: isOptimisticMessage ? Image.file(File(imgUrl)) : Image.network(imgUrl)),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(time, style: const TextStyle(color: Colors.white54, fontSize: 10)),
                        ),
                      ],
                      if (message.isNotEmpty) Text(message, style: const TextStyle(color: Colors.white, fontSize: 14)),
                    ],
                  ),
                ),
                if (!isImage)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(time, style: const TextStyle(color: Colors.white54, fontSize: 10)),
                  ),
              ],
            ),
          ),
        ),
        if (lastMessageSenderId == msgId)
          Padding(
            padding: const EdgeInsets.only(top: 2, right: 4, left: 4),
            child: Text(
              msgSeen
                  ? "seen"
                  : isOptimisticMessage
                  ? "sending..."
                  : "sent",
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ),
      ],
    ),
  );
}

Widget _typingBubble({required bool isSender}) {
  return Align(
    alignment: AlignmentGeometry.centerLeft,
    child: CustomPaint(
      painter: ChatBubblePaint(color: const Color(0xFF333333), isSender: isSender),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
        child: Text(
          "•••",
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}
