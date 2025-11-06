import 'package:web_socket_channel/io.dart';
import 'dart:convert';

class SocketService {
  late IOWebSocketChannel channel;

  Future<void> initSocket(String baseUrl, {Map<String, dynamic>? query}) async {
    final token = query?['token'];
    final uri = Uri.parse('$baseUrl?token=$token');

    print('🌐 Connecting to WebSocket: $uri');

    try {
      channel = IOWebSocketChannel.connect(uri);
      print('✅ WebSocket connected successfully to $uri');

      // Listen for incoming messages
      channel.stream.listen(
            (message) {
          print('📩 [SOCKET MESSAGE]');
          try {
            final decoded = jsonDecode(message);
            print(const JsonEncoder.withIndent('  ').convert(decoded));
          } catch (e) {
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

  void send(dynamic data) {
    try {
      final jsonData = jsonEncode(data);
      print('🚀 Sending data → $jsonData');
      channel.sink.add(jsonData);
    } catch (e) {
      print('⚠️ Error sending data: $e');
    }
  }

  void close() {
    print('🔌 Closing WebSocket connection...');
    channel.sink.close();
  }
}
