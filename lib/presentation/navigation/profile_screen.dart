import 'package:flutter/material.dart';
import 'package:antigravity/domain/auth/auth_service.dart';
import 'package:antigravity/presentation/profile/onboarding_screen.dart';
import 'package:antigravity/presentation/navigation/premium_screen.dart';
import 'package:antigravity/presentation/theme/zen_design_system.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZenColors.sand,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(ZenTheme.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Membership'),
                  _buildProfileTile(context, Icons.star_rounded, 'Premium Journey', () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PremiumScreen()));
                  }),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Settings'),
                  _buildProfileTile(context, Icons.person_outline_rounded, 'Personalize My Flow', () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OnboardingScreen()));
                  }),
                  _buildProfileTile(context, Icons.notifications_none_rounded, 'Notifications', () {}),
                  _buildProfileTile(context, Icons.security_rounded, 'Privacy & Peace', () {}),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Support'),
                  _buildProfileTile(context, Icons.help_outline_rounded, 'Sanctuary Help', () {}),
                  _buildProfileTile(context, Icons.info_outline_rounded, 'About AntiGravity', () {}),
                  const SizedBox(height: 48),
                  _buildSignOutButton(context),
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
      backgroundColor: ZenColors.sand,
      elevation: 0,
      pinned: true,
      centerTitle: false,
      title: Text(
        'Profile',
        style: GoogleFonts.lora(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: ZenColors.deepTeal,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: ZenColors.slateGray,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [ZenColors.sageGreen, ZenColors.deepTeal]),
          ),
          child: const CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200'),
          ),
        ),
        const SizedBox(width: 20),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sarah Chen',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: ZenColors.deepTeal,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Premium Member since 2024',
              style: TextStyle(color: ZenColors.slateGray, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileTile(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ZenTheme.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(icon, color: ZenColors.sageGreen, size: 22),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: ZenColors.deepTeal),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: ZenColors.slateGray, size: 20),
        onTap: onTap,
      ),
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
          side: const BorderSide(color: Colors.redAccent, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ZenTheme.radiusMedium)),
        ),
        child: const Text('Sign out of Sanctuary', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
