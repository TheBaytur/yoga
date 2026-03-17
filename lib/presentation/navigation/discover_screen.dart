import 'package:flutter/material.dart';
import 'package:antigravity/presentation/practice/practice_screen.dart';
import 'package:antigravity/domain/models/yoga_session.dart';
import 'package:antigravity/presentation/theme/zen_design_system.dart';
import 'package:google_fonts/google_fonts.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Vinyasa', 'Hatha', 'Yin', 'Meditation', 'Power'];

  final List<YogaSession> _allSessions = [
    YogaSession(
      id: '1',
      title: 'Vinyasa Flow',
      videoUrl: '',
      thumbnailUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400',
      instructor: 'Elena Brower',
      level: Difficulty.beginner,
      duration: const Duration(minutes: 20),
    ),
    YogaSession(
      id: '2',
      title: 'Power Yoga',
      videoUrl: '',
      thumbnailUrl: 'https://images.unsplash.com/photo-1510894347713-fc3ad6cb03?w=400',
      instructor: 'Michael R.',
      level: Difficulty.intermediate,
      duration: const Duration(minutes: 30),
    ),
    YogaSession(
      id: '3',
      title: 'Morning Yin',
      videoUrl: '',
      thumbnailUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=400',
      instructor: 'Sarah J.',
      level: Difficulty.beginner,
      duration: const Duration(minutes: 15),
    ),
    YogaSession(
      id: '4',
      title: 'Guided Breathwork',
      videoUrl: '',
      thumbnailUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=400',
      instructor: 'Dr. Zen',
      level: Difficulty.beginner,
      duration: const Duration(minutes: 10),
    ),
  ];

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
              padding: const EdgeInsets.symmetric(horizontal: ZenTheme.paddingLarge),
              child: Column(
                children: [
                   const SizedBox(height: 16),
                  _buildSearchBar(),
                  const SizedBox(height: 24),
                  _buildCategoryFilter(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _buildSessionGrid(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: ZenColors.sand,
      elevation: 0,
      pinned: true,
      title: Text(
        'Library',
        style: GoogleFonts.lora(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: ZenColors.deepTeal,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ZenTheme.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search sessions, instructors...',
          hintStyle: TextStyle(color: ZenColors.slateGray.withOpacity(0.5)),
          prefixIcon: const Icon(Icons.search_rounded, color: ZenColors.sageGreen),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedCategory == cat;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? ZenColors.deepTeal : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  if (!isSelected)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: Text(
                cat,
                style: TextStyle(
                  color: isSelected ? Colors.white : ZenColors.deepTeal,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSessionGrid() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: ZenTheme.paddingLarge),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final session = _allSessions[index % _allSessions.length];
            return _buildSessionCard(session);
          },
          childCount: 10, // Mock count
        ),
      ),
    );
  }

  Widget _buildSessionCard(YogaSession session) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PracticeScreen(session: session),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ZenTheme.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
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
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: ZenColors.sageGreen.withOpacity(0.1),
                    child: const Icon(Icons.spa_rounded, color: ZenColors.sageGreen),
                  ),
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
                    '${session.instructor} • ${session.duration.inMinutes}m',
                    style: TextStyle(
                      fontSize: 11,
                      color: ZenColors.slateGray.withOpacity(0.7),
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
