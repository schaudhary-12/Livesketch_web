
# LiveSketch (Flutter)

A Flutter rewrite of the LiveSketch project: a collaborative whiteboard app with drawing canvas, undo/redo, color & width picker, optional WebSocket sync, and room IDs.

## 🚀 Run
```bash
flutter pub get
flutter run
```

## 🔌 Configure WebSocket (optional)
Edit `lib/services/socket_service.dart` and set `wsBaseUrl` to your server (`ws://` or `wss://`).  
The client publishes and listens on `{wsBaseUrl}/rooms/{roomId}`.

## ✨ Features
- Drawing canvas (CustomPainter)
- Undo / Redo / Clear
- Color & stroke width picker
- Room ID input to separate sessions
- WebSocket sync (send/receive strokes as JSON)
- Provider-less simple state (setState) for clarity

## 📁 Structure
```
lib/
  main.dart
  screens/drawing_screen.dart
  models/stroke.dart
  painters/sketch_painter.dart
  services/socket_service.dart
```

## 🧑‍💻 Notes
- WebSocket is optional—works locally without backend.
- Strokes are sent as JSON with fields: points[x,y], color (ARGB int), strokeWidth, roomId.
