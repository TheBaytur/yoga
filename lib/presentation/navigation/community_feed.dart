import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:antigravity/data/services/social_service.dart';
import 'package:antigravity/presentation/theme/zen_design_system.dart';
import 'package:google_fonts/google_fonts.dart';

class CommunityFeed extends StatelessWidget {
  const CommunityFeed({super.key});

  @override
  Widget build(BuildContext context) {
    final socialService = SocialService();

    return Scaffold(
      backgroundColor: ZenColors.sand,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLiveNowSection(),
                const Padding(
                  padding: EdgeInsets.fromLTRB(ZenTheme.paddingLarge, 24, ZenTheme.paddingLarge, 8),
                  child: Text(
                    'Recent Shared Moments',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ZenColors.deepTeal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: socialService.getCommunityFeed(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 48),
                        const SizedBox(height: 16),
                        Text('Unable to reach the flow.', style: TextStyle(color: ZenColors.slateGray.withOpacity(0.7))),
                        TextButton(onPressed: () {}, child: const Text('Try Again')),
                      ],
                    ),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: ZenColors.deepTeal)));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return SliverToBoxAdapter(child: _buildEmptyState());
              }

              return SliverPadding(
                padding: const EdgeInsets.all(ZenTheme.paddingLarge),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final post = snapshot.data!.docs[index];
                      return _PostCard(post: post);
                    },
                    childCount: snapshot.data!.docs.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePostDialog(context),
        backgroundColor: ZenColors.sageGreen,
        child: const Icon(Icons.add_comment_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: ZenColors.sand,
      elevation: 0,
      pinned: true,
      title: Text(
        'Community',
        style: GoogleFonts.lora(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: ZenColors.deepTeal,
        ),
      ),
    );
  }

  Widget _buildLiveNowSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: ZenTheme.paddingLarge, vertical: 16),
          child: Row(
            children: [
              Icon(Icons.circle, color: Colors.red, size: 8),
              SizedBox(width: 8),
              Text(
                'LIVE NOW',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: ZenColors.slateGray,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: ZenTheme.paddingLarge),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [ZenColors.sageGreen, ZenColors.deepTeal],
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=user$index'),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Yogi ${index + 1}',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline_rounded, size: 60, color: ZenColors.slateGray.withOpacity(0.2)),
            const SizedBox(height: 16),
            Text(
              'No posts yet. Be the first to share!',
              style: TextStyle(color: ZenColors.slateGray.withOpacity(0.5)),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Share your progress'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: "How was your practice today?",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              SocialService().createPost('user_123', 'Yogi Sarah', controller.text);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: ZenColors.deepTeal),
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final QueryDocumentSnapshot post;
  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    final data = post.data() as Map<String, dynamic>;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ZenTheme.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: ZenColors.sageGreen.withOpacity(0.1),
                child: Text(
                  data['userName'][0],
                  style: const TextStyle(color: ZenColors.sageGreen, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['userName'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text('2h ago', style: TextStyle(fontSize: 10, color: ZenColors.slateGray.withOpacity(0.5))),
                ],
              ),
              const Spacer(),
              const Icon(Icons.more_horiz_rounded, color: ZenColors.slateGray),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            data['content'],
            style: const TextStyle(fontSize: 14, height: 1.5, color: ZenColors.deepTeal),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _InteractionButton(
                icon: Icons.favorite_border_rounded,
                label: '${data['likes'] ?? 0}',
                onTap: () => SocialService().likePost(post.id),
              ),
              const SizedBox(width: 24),
              _InteractionButton(
                icon: Icons.chat_bubble_outline_rounded,
                label: 'Reply',
                onTap: () {},
              ),
              const Spacer(),
              _InteractionButton(
                icon: Icons.share_outlined,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InteractionButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final VoidCallback onTap;

  const _InteractionButton({required this.icon, this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 18, color: ZenColors.slateGray),
          if (label != null) ...[
            const SizedBox(width: 6),
            Text(label!, style: const TextStyle(fontSize: 12, color: ZenColors.slateGray)),
          ],
        ],
      ),
    );
  }
}
