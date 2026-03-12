import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:antigravity/domain/pose_logic.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  CameraController? _cameraController;
  final YogaPoseAnalyzer _poseAnalyzer = YogaPoseAnalyzer();
  List<Pose> _poses = [];
  bool _isProcessing = false;
  String _feedbackText = "Position yourself in frame";

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    // Prefer front camera
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.low,
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
      debugPrint("Error processing pose: \$e");
    } finally {
      _isProcessing = false;
    }
  }

  void _analyzePoses(List<Pose> poses) {
    if (poses.isEmpty) {
      _feedbackText = "No pose detected";
      return;
    }

    // Simplistic analysis example. You can add more complex logic here.
    final pose = poses.first;
    
    // Check if shoulders are visible as a basic check
    final leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
    final rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];

    if (leftShoulder != null && rightShoulder != null && 
        leftShoulder.likelihood > 0.8 && rightShoulder.likelihood > 0.8) {
      _feedbackText = "Perfect! Hold for 5s";
    } else {
      _feedbackText = "Straighten your back";
    }
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    final camera = _cameraController!.description;
    final sensorOrientation = camera.sensorOrientation;
    
    InputImageRotation? rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw as int);
    // On web or some platforms format might be missing, handling basic android/ios here
    if (format == null && image.format.raw != null) {
        // Fallback or skip if format unsupported
    }

    // This is a simplified input image creation. It's often more complex depending on platform (iOS/Android BGRA/YUV).
    // For a robust implementation, the google_mlkit_pose_detection example code provides a full mapping.
    // Assuming format is natively supported by MLKit (like nv21/yuv420 or bgra8888).
    
    return InputImage.fromBytes(
      bytes: image.planes[0].bytes, // Only using first plane for simplicity in this example
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format ?? InputImageFormat.yuv_420_888, // Defaulting as example
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    _poseAnalyzer.dispose();
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
          // 1. Live Video Feed
          CameraPreview(_cameraController!),
          
          // 2. Skeletal Overlay
          CustomPaint(
            painter: PosePainter(
              _poses,
              Size(_cameraController!.value.previewSize!.height, _cameraController!.value.previewSize!.width),
              // Camera on most mobile devices is rotated 90 deg usually. Need size mapped.
              _cameraController!.description.lensDirection,
            ),
          ),
          
          // 3. User Guidance
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  _feedbackText,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          
          // Back button
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.of(context).pop(),
            ),
          )
        ],
      ),
    );
  }
}

// Simple Painter for Pose Overlay
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
      ..color = Colors.greenAccent;

    for (final pose in poses) {
      pose.landmarks.forEach((_, landmark) {
        canvas.drawCircle(
          Offset(
            cameraLensDirection == CameraLensDirection.front 
                ? size.width - (landmark.x * scaleX) // mirror for front camera
                : landmark.x * scaleX,
            landmark.y * scaleY,
          ),
          5,
          paint..style = PaintingStyle.fill,
        );
      });
      // Additional lines connecting joints could be drawn here.
    }
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.poses != poses;
  }
}
