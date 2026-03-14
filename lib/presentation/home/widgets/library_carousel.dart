import 'package:flutter/material.dart';
import 'package:antigravity/presentation/theme/zen_design_system.dart';
import 'package:antigravity/domain/models/yoga_session.dart';

class LibraryCarousel extends StatelessWidget {
  final String title;
  final List<YogaSession> sessions;
  final Function(YogaSession) onSessionTap;

  const LibraryCarousel({
    super.key,
    required this.title,
    required this.sessions,
    required this.onSessionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: ZenTheme.paddingLarge),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ZenColors.deepTeal,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('See all', style: TextStyle(color: ZenColors.sageGreen)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: ZenTheme.paddingLarge - 8),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];
              return _CarouselItem(
                session: session,
                onTap: () => onSessionTap(session),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CarouselItem extends StatelessWidget {
  final YogaSession session;
  final VoidCallback onTap;

  const _CarouselItem({required this.session, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ZenTheme.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(ZenTheme.radiusMedium)),
                child: Image.network(
                  session.thumbnailUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: ZenColors.deepTeal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${session.duration.inMinutes} min • ${session.level.name.toUpperCase()}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: ZenColors.slateGray,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
