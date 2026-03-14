import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:antigravity/presentation/auth/auth_gate.dart';
import 'package:antigravity/data/services/notification_service.dart';
import 'package:antigravity/data/services/ai_service.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:antigravity/presentation/theme/zen_design_system.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize background and persistent services
  await NotificationService().initialize();
  AIService().initialize();

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
        scaffoldBackgroundColor: ZenColors.sand,
        primaryColor: ZenColors.sageGreen,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme).copyWith(
          displayLarge: GoogleFonts.lora(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: ZenColors.deepTeal,
          ),
          displayMedium: GoogleFonts.lora(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: ZenColors.deepTeal,
          ),
        ),
        colorScheme: ColorScheme.light(
          primary: ZenColors.sageGreen,
          secondary: ZenColors.earthyBrown,
          surface: ZenColors.sand,
          onPrimary: Colors.white,
          onSurface: ZenColors.deepTeal,
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ZenTheme.radiusLarge),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: ZenColors.deepTeal),
        ),
      ),
      home: const AuthGate(),
    );
  }
}
