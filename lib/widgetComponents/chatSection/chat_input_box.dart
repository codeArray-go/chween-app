import 'dart:io';

import 'package:chween_app/provider/chat_provider.dart';
import 'package:chween_app/services/image_picker_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatInputBox extends ConsumerStatefulWidget {
  const ChatInputBox({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatInputBoxState();
}

class _ChatInputBoxState extends ConsumerState<ChatInputBox> {
  final textMessageController = TextEditingController();
  File? selectedImage;

  @override
  void dispose() {
    textMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sendMessage = ref.read(chatProvider.notifier);
    final selectedUserId = ref.watch(chatProvider).selectedUser?['id'];
    final imagePicker = ImagePickerService();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF121212),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: const Color(0xFF333333)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // IMAGE PREVIEW
                  if (selectedImage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final img = await imagePicker.pickImageFromGallery();
                              if (img != null) {
                                setState(() {
                                  selectedImage = img;
                                });
                              }
                            },
                            child: Container(
                              height: 65,
                              width: 65,
                              decoration: BoxDecoration(color: const Color(0xFF2C2C2E), borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.image_outlined, color: Colors.white, size: 30),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Selected Image Preview
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(selectedImage!, height: 65, width: 65, fit: BoxFit.cover),
                              ),
                              // Remove button
                              Positioned(
                                top: -6,
                                right: -6,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedImage = null;
                                    });
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(color: Color(0xFF2C2C2E), shape: BoxShape.circle),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(Icons.close, size: 14, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: textMessageController,
                          minLines: 1,
                          maxLines: 4,
                          keyboardType: TextInputType.multiline,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                          decoration: const InputDecoration(
                            isDense: true,
                            hintText: 'Type your message...',
                            hintStyle: TextStyle(color: Colors.white38, fontSize: 16),
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      if (selectedImage == null)
                        GestureDetector(
                          onTap: () async {
                            final img = await imagePicker.pickImageFromGallery();
                            if (img != null) {
                              setState(() {
                                selectedImage = img;
                              });
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(bottom: 2, left: 8),
                            child: Icon(Icons.image_outlined, color: Colors.white54, size: 26),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 10),

          // SEND BUTTON
          GestureDetector(
            onTap: () {
              if (textMessageController.text.trim().isEmpty && selectedImage == null) return;

              sendMessage.sendMessage(selectedUserId, textMessageController.text, selectedImage?.path ?? "");

              textMessageController.clear();
              setState(() {
                selectedImage = null;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 6),
              child: const Icon(Icons.check_circle_outlined, size: 42, color: Color(0xDBFFFFFF)),
            ),
          ),
        ],
      ),
    );
  }
}
