import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:antigravity/presentation/auth/login_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: AntiGravityApp(),
    ),
  );
}

class AntiGravityApp extends StatelessWidget {
  const AntiGravityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Sanctuary',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFFAF7F2),
        primaryColor: const Color(0xFF6B8A7A),
        fontFamily: 'Inter', // Default sans-serif font
      ),
      home: const LoginScreen(),
    );
  }
}
