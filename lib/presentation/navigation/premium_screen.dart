import 'package:flutter/material.dart';
import 'package:antigravity/data/services/subscription_service.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final subscriptionService = SubscriptionService();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      appBar: AppBar(
        title: const Text('Premium Access', style: TextStyle(color: Color(0xFF4A5D53))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF4A5D53)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.star_rounded, size: 80, color: Color(0xFFA67B5B)),
            const SizedBox(height: 16),
            const Text(
              'Unlock Your Full Potential',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF4A5D53)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Join thousands of yogis elevating their practice with AI-powered correction and exclusive sessions.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            _buildFeatureRow(Icons.videocam, '4K Adaptive HLS Streaming'),
            _buildFeatureRow(Icons.auto_awesome, 'Real-time AI Pose Feedback'),
            _buildFeatureRow(Icons.download, 'Offline Mode & Audio Guidance'),
            _buildFeatureRow(Icons.analytics, 'Detailed Biometric Insights'),
            const SizedBox(height: 48),
            _buildPlanCard('Monthly', '\$14.99/mo', 'Best for flexibility'),
            const SizedBox(height: 16),
            _buildPlanCard('Yearly', '\$99.99/yr', 'Save 45% - Best value', isPopular: true),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6B8A7A), size: 24),
          const SizedBox(width: 16),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildPlanCard(String title, String price, String subtitle, {bool isPopular = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isPopular ? const Color(0xFF6B8A7A) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF6B8A7A).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: isPopular ? Colors.white : const Color(0xFF4A5D53),
                )),
                Text(subtitle, style: TextStyle(
                  color: isPopular ? Colors.white70 : Colors.grey,
                )),
              ],
            ),
          ),
          Text(price, style: TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.bold,
            color: isPopular ? Colors.white : const Color(0xFF6B8A7A),
          )),
        ],
      ),
    );
  }
}
