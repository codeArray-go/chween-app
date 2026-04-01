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
      print("RECONNECTED");
      _registerEvents();
    });
  }

  void _registerEvents() {
    final chatsProvider = ref.read(chatProvider.notifier);
    socketService.socket?.off("getOnlineUsers");
    socketService.socket?.on("getOnlineUsers", (data) {
      chatsProvider.getOnlineUsers(data);
    });

    socketService.socket!.on("newMessage", (message) {
      chatsProvider.liveMessage(message);
    });
  }
}
