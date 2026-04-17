import 'package:chween_app/provider/chat_provider.dart';
import 'package:chween_app/services/socket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client_flutter/socket_io_client_flutter.dart';

final socketManagerProvider = Provider((ref) {
  final socketService = SocketService();

  return SocketManager(socketService, ref);
});

class SocketManager {
  final SocketService socketService;
  final Ref ref;

  SocketManager(this.socketService, this.ref);

  void connect(dynamic token) {
    socketService.connect(token);

    socketService.socket?.on('connect', (_) {
      _registerEvents();
    });

    socketService.socket?.onReconnect((_) {
      _registerEvents();
    });
  }

  void disconnect() {
    socketService.disconnect();
  }

  void _registerEvents() {
    final socket = socketService.socket;

    final chatsProvider = ref.read(chatProvider.notifier);

    socket?.off("getOnlineUsers");
    socket?.off("unreadCount");
    socket?.off("typing");
    socket?.off("stopTyping");

    socket?.on("getOnlineUsers", (data) {
      chatsProvider.getOnlineUsers(data);
    });

    socket?.on("unreadCount", (data) {
      chatsProvider.notSeenMessage(int.parse(data['sender']), data['count']);
    });

    socket?.on("typing", (senderId) {
      chatsProvider.initTypingListener(senderId);
    });

    socket?.on("stopTyping", (senderId) {
      chatsProvider.stopTypingListener(senderId);
    });
  }

  void subscribeToChat() {
    final socket = socketService.socket;
    final chatsProvider = ref.read(chatProvider.notifier);

    socket?.off("messagesSeenByPeer");
    socket?.off("newMessage");
    socket?.off("unreadCountUpdateAfterSeen");
    socket?.off("DeletedMsgId");

    socket?.on("newMessage", (message) {
      chatsProvider.liveMessage(message);
    });

    socket?.on("messagesSeenByPeer", (peerId) {
      chatsProvider.setChats(int.parse(peerId));
    });

    socket?.on("unreadCountUpdateAfterSeen", (data) {
      chatsProvider.notSeenMessage(data['sender'], data['count']);
    });

    socket?.on("DeletedMsgId", (messageId) {
      chatsProvider.chatAfterDelete(int.parse(messageId));
    });
  }

  void unSubscribeToChat() {
    final socket = socketService.socket;

    socket?.off("messagesSeenByPeer");
    socket?.off("newMessage");
    socket?.off("unreadCountUpdateAfterSeen");
    socket?.off("DeletedMsgId");
  }

  void emmitSeenStatus(Map<String, dynamic> data) {
    socketService.socket?.emit("markMessagesAsSeen", data);
  }
}
