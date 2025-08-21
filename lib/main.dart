
import 'package:flutter/material.dart';
import 'screens/drawing_screen.dart';

void main() {
  runApp(const LiveSketchApp());
}

class LiveSketchApp extends StatelessWidget {
  const LiveSketchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LiveSketch',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const DrawingScreen(),
    );
  }
}
