import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF7F2),
        elevation: 0,
        title: const Text(
          'Calendar',
          style: TextStyle(color: Color(0xFF4A5D53)),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF4A5D53)),
      ),
      body: const Center(
        child: Text(
          'Your schedule will appear here.',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFFA67B5B),
          ),
        ),
      ),
    );
  }
}
