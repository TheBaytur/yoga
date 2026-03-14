import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'dart:math' as math;

class YogaPoseAnalyzer {
  final PoseDetector _poseDetector = PoseDetector(
    options: PoseDetectorOptions(mode: PoseDetectionMode.stream)
  );

  // Logic to calculate the angle between three points (e.g., Hip, Knee, Ankle)
  double calculateAngle(PoseLandmark first, PoseLandmark middle, PoseLandmark last) {
    double angle = (math.atan2(last.y - middle.y, last.x - middle.x) -
            math.atan2(first.y - middle.y, first.x - middle.x))
        .abs();

    if (angle > math.pi) {
      angle = 2 * math.pi - angle;
    }
    return angle * (180.0 / math.pi); // Convert to degrees
  }

  Future<List<Pose>> processImage(InputImage inputImage) async {
    return await _poseDetector.processImage(inputImage);
  }

  String getFeedback(Pose pose) {
    final leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
    final rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
    final leftElbow = pose.landmarks[PoseLandmarkType.leftElbow];
    final rightElbow = pose.landmarks[PoseLandmarkType.rightElbow];
    final leftHip = pose.landmarks[PoseLandmarkType.leftHip];

    if (leftShoulder == null || rightShoulder == null) return "Adjusting view...";

    // Simple height check
    if (leftShoulder.y < 100) return "Lower your shoulders";

    // Check arm extension
    if (leftElbow != null && rightElbow != null) {
      final armAngle = calculateAngle(leftShoulder, leftElbow, leftHip!); // Example
      if (armAngle < 160) return "Straighten your arms";
    }

    return "Great form! Hold it.";
  }

  void dispose() {
    _poseDetector.close();
  }
}
