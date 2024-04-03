import 'package:flutter/material.dart';

import 'map_example/map_view.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Map View',
      home: MapView(),
    );
  }
}
