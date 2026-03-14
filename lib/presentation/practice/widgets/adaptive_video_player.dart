import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:antigravity/domain/models/yoga_session.dart';

class AdaptiveVideoPlayer extends StatefulWidget {
  final YogaSession session;

  const AdaptiveVideoPlayer({super.key, required this.session});

  @override
  State<AdaptiveVideoPlayer> createState() => _AdaptiveVideoPlayerState();
}

class _AdaptiveVideoPlayerState extends State<AdaptiveVideoPlayer> {
  late BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    super.initState();
    
    BetterPlayerDataSource betterPlayerDataSource;
    
    if (widget.session.localVideoPath != null) {
      betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.file,
        widget.session.localVideoPath!,
      );
    } else {
      betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.session.hlsVideoUrl ?? widget.session.videoUrl,
        liveStream: false,
        useAsmsSubtitles: true,
        useAsmsTracks: true,
      );
    }

    BetterPlayerConfiguration betterPlayerConfiguration = const BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
      autoPlay: true,
      looping: false,
      allowedScreenSleep: false,
    );

    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(betterPlayerDataSource);
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: BetterPlayer(
        controller: _betterPlayerController,
      ),
    );
  }
}
