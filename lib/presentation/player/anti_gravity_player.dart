import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AntiGravityPlayer extends StatefulWidget {
  final String url;
  const AntiGravityPlayer({super.key, required this.url});

  @override
  State<AntiGravityPlayer> createState() => _AntiGravityPlayerState();
}

class _AntiGravityPlayerState extends State<AntiGravityPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          : const CircularProgressIndicator(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
