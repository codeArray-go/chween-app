import 'package:flutter/material.dart';

class ChatSkeleton extends StatelessWidget {
  const ChatSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final Color bgColor = const Color(0xFF121212);

    return Scaffold(
      backgroundColor: bgColor,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildBubble(isSender: false, width: 100),
          _buildBubble(isSender: true, width: 150),
          _buildBubble(isSender: true, width: 100),
          _buildBubble(isSender: false, width: 120),
          _buildBubble(isSender: false, width: 130),
          _buildBubble(isSender: false, width: 140),
          _buildBubble(isSender: true, width: 120),
          _buildBubble(isSender: false, width: 260),
          _buildBubble(isSender: true, width: 160),
          _buildBubble(isSender: true, width: 140),
          _buildBubble(isSender: false, width: 180),
          _buildBubble(isSender: true, width: 60),
        ],
      ),
    );
  }

  Widget _buildBubble({required bool isSender, required double width}) {
    final Color chatColor = const Color(0xFF333333);

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        width: width,
        height: 30,
        decoration: BoxDecoration(
          color: chatColor,
          borderRadius: BorderRadius.circular(
            16,
          ).copyWith(bottomLeft: isSender ? const Radius.circular(16) : const Radius.circular(4), bottomRight: isSender ? const Radius.circular(4) : const Radius.circular(16)),
        ),
      ),
    );
  }
}
