import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:antigravity/data/services/social_service.dart';

class CommunityFeed extends StatelessWidget {
  const CommunityFeed({super.key});

  @override
  Widget build(BuildContext context) {
    final socialService = SocialService();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      appBar: AppBar(
        title: const Text('Community', style: TextStyle(color: Color(0xFF4A5D53))),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: socialService.getCommunityFeed(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final post = snapshot.data!.docs[index];
              return _PostCard(post: post);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePostDialog(context),
        backgroundColor: const Color(0xFF6B8A7A),
        child: const Icon(Icons.add_comment),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('No posts yet. Be the first to share!', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share your progress'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(hintText: "How was your practice today?"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              SocialService().createPost('user_123', 'Yogi Sarah', controller.text);
              Navigator.pop(context);
            },
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
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundColor: const Color(0xFF6B8A7A), child: Text(data['userName'][0])),
                const SizedBox(width: 12),
                Text(data['userName'], style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                const Icon(Icons.more_horiz),
              ],
            ),
            const SizedBox(height: 12),
            Text(data['content']),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border, size: 20),
                  onPressed: () => SocialService().likePost(post.id),
                ),
                Text('${data['likes']} likes'),
                const SizedBox(width: 16),
                const Icon(Icons.chat_bubble_outline, size: 20),
                const SizedBox(width: 4),
                const Text('Reply'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
