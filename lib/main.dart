import 'package:flutter/material.dart';
import 'package:triqui_app/triqui_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'triqui App',
      debugShowCheckedModeBanner: false,
      home: TriquiApp(),
    );
  }
}
