import 'package:flutter/material.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Фокус"),
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xFF4A6572),
        child: Center(
            child: Text(
          "Focus",
          style: TextStyle(color: Colors.white, fontSize: 30),
        )),
      ),
    );
  }
}
