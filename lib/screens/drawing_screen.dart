
import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/stroke.dart';
import '../painters/sketch_painter.dart';
import '../services/socket_service.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  final List<Stroke> _strokes = [];
  final List<Stroke> _redo = [];
  Stroke? _current;

  Color _color = Colors.indigo;
  double _width = 4.0;
  bool _useSocket = false;
  late SocketService _socket;
  final TextEditingController _roomCtrl = TextEditingController(text: 'default');

  @override
  void dispose() {
    _socket.dispose();
    _roomCtrl.dispose();
    super.dispose();
  }

  void _connectSocket() {
    _socket = SocketService(
      onStroke: (remote) {
        if (remote.roomId != _roomCtrl.text) return;
        setState(() => _strokes.add(remote));
      },
      roomId: _roomCtrl.text,
    );
    _socket.connect();
  }

  void _start(PointerDownEvent e) {
    setState(() {
      _redo.clear();
      _current = Stroke(points: [e.localPosition], color: _color.value, strokeWidth: _width, roomId: _roomCtrl.text);
    });
  }

  void _update(PointerMoveEvent e) {
    if (_current == null) return;
    setState(() {
      _current!.points.add(e.localPosition);
    });
  }

  void _end(PointerUpEvent e) {
    if (_current == null) return;
    setState(() {
      _current!.points.add(e.localPosition);
      _strokes.add(_current!);
      if (_useSocket) {
        _socket.sendStroke(_current!);
      }
      _current = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LiveSketch (Flutter)'),
        actions: [
          IconButton(
            tooltip: 'Undo',
            onPressed: _strokes.isEmpty ? null : () => setState(() => _redo.add(_strokes.removeLast())),
            icon: const Icon(Icons.undo),
          ),
          IconButton(
            tooltip: 'Redo',
            onPressed: _redo.isEmpty ? null : () => setState(() => _strokes.add(_redo.removeLast())),
            icon: const Icon(Icons.redo),
          ),
          IconButton(
            tooltip: 'Clear',
            onPressed: _strokes.isEmpty && _current == null ? null : () => setState(() { _strokes.clear(); _redo.clear(); }),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: Column(
        children: [
          _controls(),
          Expanded(
            child: Listener(
              onPointerDown: _start,
              onPointerMove: _update,
              onPointerUp: _end,
              child: Container(
                color: Colors.white,
                child: CustomPaint(
                  painter: SketchPainter(_strokes, _current),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _controls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Room:'),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _roomCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Enter room id',
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  const Text('WS'),
                  Switch(
                    value: _useSocket,
                    onChanged: (v) {
                      setState(() => _useSocket = v);
                      if (v) _connectSocket();
                      if (!v) _socket.dispose();
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Color:'),
              const SizedBox(width: 8),
              for (final c in [Colors.indigo, Colors.red, Colors.green, Colors.black, Colors.orange])
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: GestureDetector(
                    onTap: () => setState(() => _color = c),
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: c,
                      child: _color == c ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                    ),
                  ),
                ),
              const SizedBox(width: 16),
              const Text('Width:'),
              Expanded(
                child: Slider(
                  value: _width,
                  min: 1,
                  max: 16,
                  onChanged: (v) => setState(() => _width = v),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
