import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:antigravity/domain/models/yoga_session.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  late GenerativeModel _model;

  void initialize() {
    _model = FirebaseVertexAI.instance.generativeModel(model: 'gemini-1.5-flash');
  }

  Future<String> getPersonalizedRecommendation(String userMood, String difficultyPreference) async {
    final prompt = [
      Content.text('The user is feeling $userMood and prefers $difficultyPreference yoga. '
          'Suggest a specific type of yoga session and explain why in one poetic sentence.')
    ];

    try {
      final response = await _model.generateContent(prompt);
      return response.text ?? "A gentle flow for a balanced day.";
    } catch (e) {
      return "Listen to your body and find your own flow.";
    }
  }

  // Future feature: recommend from existing YogaSession list
  Future<List<YogaSession>> recommendSessions(List<YogaSession> allSessions, String userGoal) async {
    // In a real app, we'd send metadata to Gemini and have it pick IDs.
    // For now, returning a subset.
    return allSessions.take(2).toList();
  }
}
