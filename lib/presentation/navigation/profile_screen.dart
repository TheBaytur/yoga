import 'package:flutter/material.dart';
import 'package:antigravity/domain/auth/auth_service.dart';
import 'package:antigravity/presentation/profile/onboarding_screen.dart';
import 'package:antigravity/presentation/navigation/premium_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF7F2),
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(color: Color(0xFF4A5D53)),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF4A5D53)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildProfileTile(context, Icons.star_outline, 'Get Premium', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PremiumScreen()));
            }),
            _buildProfileTile(context, Icons.person_outline, 'Edit Preferences', () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OnboardingScreen()));
            }),
            _buildProfileTile(context, Icons.notifications_none, 'Notifications', () {}),
            _buildProfileTile(context, Icons.security, 'Privacy & Security', () {}),
            _buildProfileTile(context, Icons.help_outline, 'Help Center', () {}),
            const SizedBox(height: 32),
            _buildSignOutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back, Sarah',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A5D53),
          ),
        ),
        Text(
          'Premium Member since March 2024',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildProfileTile(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF6B8A7A).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xFF6B8A7A)),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () async {
          await AuthService.signOut();
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.redAccent,
          side: const BorderSide(color: Colors.redAccent),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Text('Sign out'),
      ),
    );
  }
}
