import 'package:chween_app/provider/chat_provider.dart';
import 'package:chween_app/widgetComponents/chatSection/chat_header.dart';
import 'package:chween_app/widgetComponents/chatSection/chats.dart';
import 'package:chween_app/widgetComponents/skeletons/chat_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatContainer extends ConsumerWidget {
  const ChatContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatLoading = ref.watch(chatProvider).isLoading;
    final userDetail = ref.watch(chatProvider).selectedUser;

    if (userDetail == null) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      body: Column(
        children: [
          ChatHeader(),
          Container(
            height: 0.001,
            decoration: BoxDecoration(
              border: BoxBorder.symmetric(horizontal: BorderSide(color: const Color(0x27FFFFFF))),
            ),
          ),
          Expanded(child: chatLoading ? Center(child: ChatSkeleton()) : Chats()),
        ],
      ),
    );
  }
}
