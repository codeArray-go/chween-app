import 'package:socket_io_client_flutter/socket_io_client_flutter.dart' as IO;

class SocketService {
  final baseUrl = 'https://chween-bfz7.onrender.com';
  IO.Socket? socket;

  void connect(String token) {
    socket = IO.io(
      baseUrl,
      IO.OptionBuilder().setTransports(['websocket']).disableAutoConnect().enableReconnection().setReconnectionAttempts(5).setReconnectionDelay(2000).setExtraHeaders({
        'Authorization': 'Bearer $token',
      }).build(),
    );

    socket!.connect();
  }
}
