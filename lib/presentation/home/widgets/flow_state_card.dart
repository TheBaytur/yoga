import 'package:flutter/material.dart';
import 'package:antigravity/presentation/theme/zen_design_system.dart';
// glassmorphism_widgets is used via the container styling now

class FlowStateCard extends StatelessWidget {
  final String title;
  final String duration;
  final String level;
  final String imageUrl;
  final VoidCallback onResume;

  const FlowStateCard({
    super.key,
    required this.title,
    required this.duration,
    required this.level,
    required this.imageUrl,
    required this.onResume,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ZenTheme.radiusExtraLarge),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Semi-transparent overlay for readability
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ZenTheme.radiusExtraLarge),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.6),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(ZenTheme.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    _buildTag(duration),
                    const SizedBox(width: 8),
                    _buildTag(level),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: onResume,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: ZenColors.deepTeal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ZenTheme.radiusMedium),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Resume Practice', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}
