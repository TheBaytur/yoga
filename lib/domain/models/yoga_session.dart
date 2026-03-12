enum Difficulty {
  beginner,
  intermediate,
  advanced,
}

class YogaSession {
  final String id;
  final String title;
  final String videoUrl;
  final Duration duration;
  final Difficulty level;

  YogaSession({
    required this.id, 
    required this.title, 
    required this.videoUrl, 
    required this.duration, 
    required this.level
  });
}
