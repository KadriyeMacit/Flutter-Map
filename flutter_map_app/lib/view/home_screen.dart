import 'package:flutter/material.dart';
import 'package:flutter_map_app/view/direction_screen.dart';
import 'package:flutter_map_app/view/map_screen.dart';
import 'package:flutter_map_app/view/markers_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Map Sample")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildButton(context, "Map Screen", const MapScreen()),
            buildButton(context, "Markers Screen", const MarkersScreen()),
            buildButton(context, "Direction Screen", const DirectionScreen()),
          ],
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context, String text, Widget screen) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Text(text),
    );
  }
}
