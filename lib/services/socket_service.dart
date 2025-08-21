
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/stroke.dart';

typedef OnRemoteStroke = void Function(Stroke s);

class SocketService {
  SocketService({required this.onStroke, required this.roomId});

  final OnRemoteStroke onStroke;
  final String roomId;

  // Change this to your backend base URL, e.g. wss://api.example.com
  final String wsBaseUrl = 'wss://YOUR_WEBSOCKET_BASE_URL';

  WebSocketChannel? _channel;

  void connect() {
    if (!wsBaseUrl.startsWith('ws')) return;
    final url = '$wsBaseUrl/rooms/$roomId';
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel!.stream.listen((event) {
      try {
        final data = jsonDecode(event as String);
        final type = data['type'];
        if (type == 'stroke') {
          onStroke(Stroke.fromJson(data));
        }
      } catch (_) {}
    }, onDone: () {}, onError: (_) {});
  }

  void sendStroke(Stroke s) {
    if (_channel == null) return;
    _channel!.sink.add(jsonEncode(s.toJson()));
  }

  void dispose() {
    _channel?.sink.close();
    _channel = null;
  }
}
