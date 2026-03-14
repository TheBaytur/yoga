import 'package:cloud_firestore/cloud_firestore.dart';

class SocialService {
  static final SocialService _instance = SocialService._internal();
  factory SocialService() => _instance;
  SocialService._internal();

  final _db = FirebaseFirestore.instance;

  // Real-time stream of community posts
  Stream<QuerySnapshot> getCommunityFeed() {
    return _db.collection('community_posts').orderBy('timestamp', descending: true).limit(50).snapshots();
  }

  // Create a post
  Future<void> createPost(String userId, String userName, String content, {String? imageUrl}) async {
    await _db.collection('community_posts').add({
      'userId': userId,
      'userName': userName,
      'content': content,
      'imageUrl': imageUrl,
      'likes': 0,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Like a post
  Future<void> likePost(String postId) async {
    await _db.collection('community_posts').doc(postId).update({
      'likes': FieldValue.increment(1),
    });
  }

  // Real-time group session updates (for future "practice together")
  Stream<DocumentSnapshot> getGroupSession(String sessionId) {
    return _db.collection('group_sessions').doc(sessionId).snapshots();
  }
}
