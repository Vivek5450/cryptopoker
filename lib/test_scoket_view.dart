import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class TestSocketView extends StatefulWidget {
  const TestSocketView({super.key});

  @override
  State<TestSocketView> createState() => _TestSocketViewState();
}

class _TestSocketViewState extends State<TestSocketView> {
  late WebSocketChannel channel;
  String logText = "Connecting...";

  @override
  void initState() {
    super.initState();
    connectSocket();
  }

  void connectSocket() {
    try {
      channel = IOWebSocketChannel.connect(Uri.parse("ws://157.245.212.69/ws"));

      channel.stream.listen(
            (message) {
          setState(() {
            logText += "\n📩 Received:\n$message\n";
          });

          try {
            final decoded = jsonDecode(message);
            debugPrint("🔍 JSON Data: $decoded");
          } catch (e) {
            debugPrint("⚠️ Not valid JSON: $message");
          }
        },
        onError: (error) {
          setState(() {
            logText += "\n❌ Error: $error\n";
          });
        },
        onDone: () {
          setState(() {
            logText += "\n🔌 Connection closed\n";
          });
        },
      );

      setState(() {
        logText = "✅ Connected to ws://157.245.212.69/ws\n";
      });
    } catch (e) {
      setState(() {
        logText = "❌ Failed to connect: $e";
      });
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("WebSocket Debugger"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Text(
            logText,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Try sending a test message if server supports it
          channel.sink.add(jsonEncode({
            "event": "test",
            "message": "Hello from client 👋"
          }));
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.send),
      ),
    );
  }
}
