import 'package:flutter/material.dart';
import 'package:antigravity/presentation/practice/practice_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2), // Light beige
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _HeaderSection(),
              SizedBox(height: 32),
              _ContinuePracticeSection(),
              SizedBox(height: 32),
              _FeaturedCollectionsSection(),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'THE SANCTUARY',
                style: TextStyle(
                  fontFamily: 'Georgia', // Serif font for elegance
                  fontSize: 18,
                  letterSpacing: 2.0,
                  color: const Color(0xFF6B8A7A), // Sage Green
                  fontWeight: FontWeight.w500,
                ),
              ),
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFFE5D5C5), // Soft brown/beige
                child: const Text('S', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Text(
            'Good morning, Sarah',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 32,
              color: const Color(0xFF4A5D53), // Darker Sage
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ready for your practice?',
            style: TextStyle(
              fontSize: 16,
              color: const Color(0xFFA67B5B), // Earthy brown/dusty orange
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 40,
            height: 2,
            decoration: BoxDecoration(
              color: const Color(0xFFA67B5B).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContinuePracticeSection extends StatelessWidget {
  const _ContinuePracticeSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'Continue Practice',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6B8A7A), // Sage
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: 3,
            itemBuilder: (context, index) {
              final titles = ['Morning Flow', 'Vinyasa Balance', 'Evening Wind Down'];
              final times = ['15 min', '25 min', '10 min'];
              final tags = ['Sage Green/Beige', 'Earthy tones', 'Dusty Rose'];
              final progress = [0.7, 0.3, 0.1];
              
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PracticeScreen(),
                    ),
                  );
                },
                child: Container(
                  width: 260,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        child: Image.network(
                          'https://picsum.photos/seed/yoga${index}a/400/200',
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  titles[index],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  times[index],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              tags[index],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: progress[index],
                                      backgroundColor: Colors.grey[200],
                                      valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF6B8A7A)),
                                      minHeight: 4,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '\${(progress[index] * 100).toInt()}%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FeaturedCollectionsSection extends StatelessWidget {
  const _FeaturedCollectionsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'Featured Collections',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6B8A7A), // Sage
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 320,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: 3,
            itemBuilder: (context, index) {
              final titles = ['Awaken & Flow Collection', 'Find Your Zen: Meditation', 'Strength & Flexibility'];
              final subtitles = ['6 sessions', '5 classes', '8 practices'];
              final descriptions = [
                'Cultivate energy and balance your breath.',
                'Cultivate deep relaxation and focus.',
                'Build core strength and improve mobility.'
              ];
              
              return Container(
                width: 280,
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      child: Image.network(
                        'https://picsum.photos/seed/yogacollect$index/400/250',
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titles[index],
                            style: const TextStyle(
                              fontFamily: 'Georgia',
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitles[index],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildTag(index == 0 ? 'SAGE GREEN' : 'DUSTY ROSE', index == 0 ? const Color(0xFF6B8A7A) : const Color(0xFFC49A94)),
                              const SizedBox(width: 8),
                              _buildTag('BEIGE', const Color(0xFFE5D5C5)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            descriptions[index],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
