import 'package:socket_io_client_flutter/socket_io_client_flutter.dart' as i_o;

class SocketService {
  final baseUrl = 'https://chween-web.onrender.com';
  i_o.Socket? socket;

  void connect(String token) {
    socket = i_o.io(
      baseUrl,
      i_o.OptionBuilder().setTransports(['websocket']).disableAutoConnect().enableReconnection().setReconnectionAttempts(5).setReconnectionDelay(2000).setExtraHeaders({
        'Authorization': 'Bearer $token',
      }).build(),
    );

    socket!.connect();
  }

  void disconnect() {
    if (socket != null) {
      socket!.disconnect();
      socket!.dispose();
      socket = null;
    }
  }
}
