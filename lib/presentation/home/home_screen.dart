import 'package:flutter/material.dart';
import 'package:antigravity/domain/models/yoga_session.dart';
import 'package:antigravity/presentation/practice/practice_screen.dart';
import 'package:antigravity/presentation/theme/zen_design_system.dart';
import 'package:antigravity/presentation/home/widgets/zen_progress_ring.dart';
import 'package:antigravity/presentation/home/widgets/flow_state_card.dart';
import 'package:antigravity/presentation/home/widgets/zen_stat_chip.dart';
import 'package:antigravity/presentation/home/widgets/library_carousel.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZenColors.sand,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(ZenTheme.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGreetingSection(),
                  const SizedBox(height: 32),
                  _buildFlowStateSection(context),
                  const SizedBox(height: 32),
                  _buildWeeklyVitalsSection(),
                  const SizedBox(height: 32),
                  _buildLibrarySections(context),
                  const SizedBox(height: 32),
                  _buildLiveIndicator(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 80,
      backgroundColor: ZenColors.sand,
      elevation: 0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: ZenTheme.paddingLarge, vertical: 16),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop'),
            ),
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded, color: ZenColors.deepTeal),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGreetingSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning, Sarah.',
                style: GoogleFonts.lora(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: ZenColors.deepTeal,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Your path to balance starts here.',
                style: TextStyle(
                  fontSize: 16,
                  color: ZenColors.slateGray.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
        const ZenProgressRing(
          progress: 0.65,
          size: 70,
          label: 'Today\'s Goal',
        ),
      ],
    );
  }

  Widget _buildFlowStateSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Next in Your Flow',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ZenColors.deepTeal,
          ),
        ),
        const SizedBox(height: 16),
        FlowStateCard(
          title: 'Morning Sun Salutation',
          duration: '15 min',
          level: 'Beginner',
          imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=800&q=80',
          onResume: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PracticeScreen(
                  session: YogaSession(
                    id: 'morning_flow',
                    title: 'Morning Sun Salutation',
                    videoUrl: '', // Dummy for now
                    thumbnailUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=800&q=80',
                    instructor: 'Elena Brower',
                    level: Difficulty.beginner,
                    duration: const Duration(minutes: 15),
                    hlsVideoUrl: 'https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da39574d72b.m3u8',
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWeeklyVitalsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weekly Vitals',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ZenColors.deepTeal,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 70,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: const [
              ZenStatChip(emoji: '🔥', value: '5 days', label: 'Streak'),
              SizedBox(width: 12),
              ZenStatChip(emoji: '🧘', value: '120m', label: 'Total Practice'),
              SizedBox(width: 12),
              ZenStatChip(emoji: '🎯', value: '88%', label: 'Pose Accuracy'),
              SizedBox(width: 12),
              ZenStatChip(emoji: '⚡', value: '450', label: 'Calories'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLibrarySections(BuildContext context) {
    final mockSessions = [
      YogaSession(
        id: '1',
        title: 'Deep Core Strength',
        videoUrl: '',
        thumbnailUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400',
        instructor: 'Sarah J.',
        level: Difficulty.intermediate,
        duration: const Duration(minutes: 20),
      ),
      YogaSession(
        id: '2',
        title: 'Stress Relief Yoga',
        videoUrl: '',
        thumbnailUrl: 'https://images.unsplash.com/photo-1510894347713-fc3ad6cb03?w=400',
        instructor: 'Michael R.',
        level: Difficulty.beginner,
        duration: const Duration(minutes: 10),
      ),
    ];

    return Column(
      children: [
        LibraryCarousel(
          title: 'For You',
          sessions: mockSessions,
          onSessionTap: (s) {},
        ),
        const SizedBox(height: 24),
        LibraryCarousel(
          title: 'Quick Hits',
          sessions: mockSessions,
          onSessionTap: (s) {},
        ),
      ],
    );
  }

  Widget _buildLiveIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ZenColors.sageGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ZenTheme.radiusMedium),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.people_outline, color: ZenColors.sageGreen, size: 20),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Join 1,240 others practicing \'Solar Power Flow\' right now.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: ZenColors.deepTeal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
