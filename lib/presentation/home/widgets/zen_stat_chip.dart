import 'package:flutter/material.dart';
import 'package:antigravity/presentation/theme/zen_design_system.dart';

class ZenStatChip extends StatelessWidget {
  final String label;
  final String value;
  final String emoji;

  const ZenStatChip({
    super.key,
    required this.label,
    required this.value,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ZenTheme.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: ZenColors.deepTeal,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: ZenColors.slateGray,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
