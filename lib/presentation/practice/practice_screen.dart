import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:antigravity/presentation/practice/widgets/adaptive_video_player.dart';
import 'package:antigravity/presentation/practice/widgets/audio_guidance_player.dart';
import 'package:antigravity/domain/models/yoga_session.dart';
import 'package:antigravity/domain/pose_logic.dart';

class PracticeScreen extends StatefulWidget {
  final YogaSession session;
  const PracticeScreen({super.key, required this.session});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  CameraController? _cameraController;
  final YogaPoseAnalyzer _poseAnalyzer = YogaPoseAnalyzer();
  final AudioGuidancePlayer _audioPlayer = AudioGuidancePlayer();
  List<Pose> _poses = [];
  bool _isProcessing = false;
  bool _isAudioOnly = false;
  String _feedbackText = "Position yourself in frame";

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController!.initialize();

    if (!mounted) return;

    setState(() {});

    _cameraController!.startImageStream((CameraImage image) {
      if (!_isProcessing) {
        _processCameraImage(image);
      }
    });
  }

  Future<void> _processCameraImage(CameraImage image) async {
    _isProcessing = true;

    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) {
      _isProcessing = false;
      return;
    }

    try {
      final poses = await _poseAnalyzer.processImage(inputImage);
      if (mounted) {
        setState(() {
          _poses = poses;
          _analyzePoses(poses);
        });
      }
    } catch (e) {
      debugPrint("Error processing pose: $e");
    } finally {
      _isProcessing = false;
    }
  }

  void _analyzePoses(List<Pose> poses) {
    if (poses.isEmpty) {
      _feedbackText = "No pose detected";
      return;
    }

    final pose = poses.first;
    // Basic analysis using our helper (Phase 3 expansion)
    final feedback = _poseAnalyzer.getFeedback(pose);
    setState(() {
      _feedbackText = feedback;
    });
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    final camera = _cameraController!.description;
    final sensorOrientation = camera.sensorOrientation;
    
    InputImageRotation? rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw as int);
    
    return InputImage.fromBytes(
      bytes: image.planes[0].bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format ?? InputImageFormat.yuv_420_888,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    _poseAnalyzer.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Video Layer (Adaptive OR Audio Only)
          if (!_isAudioOnly)
            AdaptiveVideoPlayer(session: widget.session)
          else
            const Center(
              child: Icon(Icons.graphic_eq, color: Color(0xFF6B8A7A), size: 120),
            ),

          // 2. Camera Overlay
          if (_isAudioOnly)
            Positioned(
              top: 60,
              right: 20,
              child: SizedBox(
                width: 120,
                height: 180,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CameraPreview(_cameraController!),
                ),
              ),
            )
          else
            CameraPreview(_cameraController!),
          
          // 3. Skeletal Overlay
          CustomPaint(
            painter: PosePainter(
              _poses,
              Size(_cameraController!.value.previewSize!.height, _cameraController!.value.previewSize!.width),
              _cameraController!.description.lensDirection,
            ),
          ),
          
          // 4. Controls & Guidance
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: const Color(0xFF6B8A7A), width: 1),
                  ),
                  child: Text(
                    _feedbackText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ActionButton(
                      icon: _isAudioOnly ? Icons.videocam : Icons.graphic_eq,
                      label: _isAudioOnly ? "Video" : "Audio Only",
                      onPressed: () {
                        setState(() {
                          _isAudioOnly = !_isAudioOnly;
                          if (_isAudioOnly) {
                            _audioPlayer.playSessionAudio(widget.session);
                          } else {
                            _audioPlayer.stop();
                          }
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Back button
          Positioned(
            top: 50,
            left: 20,
            child: FloatingActionButton.small(
              backgroundColor: Colors.black38,
              child: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          )
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton.filled(
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xFF6B8A7A),
            foregroundColor: Colors.white,
          ),
          icon: Icon(icon),
          onPressed: onPressed,
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
      ],
    );
  }
}

class PosePainter extends CustomPainter {
  final List<Pose> poses;
  final Size absoluteImageSize;
  final CameraLensDirection cameraLensDirection;

  PosePainter(this.poses, this.absoluteImageSize, this.cameraLensDirection);

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = const Color(0xFF6B8A7A);

    for (final pose in poses) {
      pose.landmarks.forEach((_, landmark) {
        canvas.drawCircle(
          Offset(
            cameraLensDirection == CameraLensDirection.front 
                ? size.width - (landmark.x * scaleX)
                : landmark.x * scaleX,
            landmark.y * scaleY,
          ),
          4,
          paint..style = PaintingStyle.fill,
        );
      });
    }
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return true;
  }
}
