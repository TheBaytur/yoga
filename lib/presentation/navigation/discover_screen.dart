import 'package:flutter/material.dart';
import 'package:antigravity/presentation/practice/practice_screen.dart';
import 'package:antigravity/domain/models/yoga_session.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF7F2),
        elevation: 0,
        title: const Text(
          'Discover',
          style: TextStyle(color: Color(0xFF4A5D53)),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF4A5D53)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Try a guided practice',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B8A7A),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PracticeScreen(
                      session: YogaSession(
                    id: '1',
                    title: 'Vinyasa Flow',
                    videoUrl: '',
                    thumbnailUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400',
                    instructor: 'Elena Brower',
                    level: Difficulty.beginner,
                    duration: const Duration(minutes: 20),
                  ),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B8A7A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Start Practice'),
            ),
          ],
        ),
      ),
    );
  }
}
