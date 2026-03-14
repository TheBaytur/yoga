import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:antigravity/domain/models/yoga_session.dart';

class AudioGuidancePlayer {
  late AudioPlayer _player;

  AudioGuidancePlayer() {
    _player = AudioPlayer();
  }

  Future<void> playSessionAudio(YogaSession session) async {
    if (session.audioUrl == null) return;

    await _player.setAudioSource(
      AudioSource.uri(
        Uri.parse(session.audioUrl!),
        tag: MediaItem(
          id: session.id,
          album: "The Sanctuary",
          title: session.title,
          artUri: Uri.parse("https://example.com/logo.png"), // Placeholder
        ),
      ),
    );
    _player.play();
  }

  Future<void> stop() async {
    await _player.stop();
  }

  void dispose() {
    _player.dispose();
  }

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
}
