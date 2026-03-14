import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:antigravity/presentation/home/home_screen.dart';
import 'package:antigravity/presentation/navigation/discover_screen.dart';
import 'package:antigravity/presentation/navigation/profile_screen.dart';
import 'package:antigravity/presentation/navigation/progress_dashboard.dart';
import 'package:antigravity/presentation/navigation/community_feed.dart';
import 'package:antigravity/presentation/theme/zen_design_system.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const DiscoverScreen(),
    const ProgressDashboard(),
    const CommunityFeed(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZenColors.sand,
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SalomonBottomBar(
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
          selectedItemColor: ZenColors.sageGreen,
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
              title: const Text('AI Cam'),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.people_rounded),
              title: const Text('Community'),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.person_rounded),
              title: const Text('Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
