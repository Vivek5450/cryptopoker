import 'package:web_socket_channel/io.dart';
import 'dart:convert';

class SocketService {
  late IOWebSocketChannel channel;

  Future<void> initSocket(String baseUrl) async {
    print('🌐 Connecting to WebSocket (no token): $baseUrl');

    try {
      channel = IOWebSocketChannel.connect(Uri.parse(baseUrl));
      print('✅ Connected successfully to $baseUrl');

      channel.stream.listen(
            (message) {
          print('\n📩 [SOCKET MESSAGE RECEIVED]');
          try {
            final decoded = jsonDecode(message);
            final formatted = const JsonEncoder.withIndent('  ').convert(decoded);
            print(formatted);
          } catch (_) {
            print('Raw message: $message');
          }
        },
        onError: (error) {
          print('⚠️ WebSocket Error: $error');
        },
        onDone: () {
          print('❌ WebSocket connection closed');
        },
      );
    } catch (e) {
      print('🚫 Failed to connect WebSocket: $e');
    }
  }

  void close() {
    print('🔌 Closing WebSocket connection...');
    channel.sink.close();
  }
}

