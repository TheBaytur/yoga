enum Difficulty {
  beginner,
  intermediate,
  advanced,
}

class YogaSession {
  final String id;
  final String title;
  final String videoUrl;
  final String? hlsVideoUrl; // Adaptive streaming URL
  final String? audioUrl;    // Audio-only guidance URL
  final String? localVideoPath; // For offline mode
  final String thumbnailUrl;
  final String instructor;
  final Duration duration;
  final Difficulty level;
  final String? description;

  YogaSession({
    required this.id, 
    required this.title, 
    required this.videoUrl, 
    required this.thumbnailUrl,
    required this.instructor,
    this.hlsVideoUrl,
    this.audioUrl,
    this.localVideoPath,
    required this.duration, 
    required this.level,
    this.description,
  });

  YogaSession copyWith({
    String? localVideoPath,
  }) {
    return YogaSession(
      id: id,
      title: title,
      videoUrl: videoUrl,
      thumbnailUrl: thumbnailUrl,
      instructor: instructor,
      hlsVideoUrl: hlsVideoUrl,
      audioUrl: audioUrl,
      localVideoPath: localVideoPath ?? this.localVideoPath,
      duration: duration,
      level: level,
      description: description,
    );
  }
}
