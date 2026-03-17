import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:antigravity/presentation/home/home_screen.dart';
import 'package:antigravity/presentation/navigation/discover_screen.dart';
import 'package:antigravity/presentation/navigation/profile_screen.dart';
import 'package:antigravity/presentation/navigation/progress_dashboard.dart';
import 'package:antigravity/presentation/navigation/community_feed.dart';
import 'package:antigravity/presentation/theme/zen_design_system.dart';
import 'package:antigravity/presentation/navigation/navigation_provider.dart';

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationProvider);

    final List<Widget> screens = [
      const HomeScreen(),
      const DiscoverScreen(),
      const ProgressDashboard(),
      const CommunityFeed(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: ZenColors.sand,
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: selectedIndex,
        onTap: (i) => ref.read(navigationProvider.notifier).state = i,
        selectedItemColor: ZenColors.deepTeal,
        unselectedItemColor: ZenColors.slateGray.withOpacity(0.5),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home_rounded),
            title: const Text('Home'),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.explore_rounded),
            title: const Text('Library'),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.analytics_rounded),
            title: const Text('Progress'),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.forum_rounded),
            title: const Text('Connect'),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person_rounded),
            title: const Text('Profile'),
          ),
        ],
      ),
    );
  }
}
