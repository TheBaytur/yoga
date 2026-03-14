import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:antigravity/domain/models/yoga_session.dart';

class OfflineSessionManager {
  static final OfflineSessionManager _instance = OfflineSessionManager._internal();
  factory OfflineSessionManager() => _instance;
  OfflineSessionManager._internal();

  Future<void> initialize() async {
    await FlutterDownloader.initialize(debug: true);
  }

  Future<String?> downloadSession(YogaSession session) async {
    final directory = await getApplicationDocumentsDirectory();
    final savePath = Directory('${directory.path}/sessions/${session.id}');
    
    if (!await savePath.exists()) {
      await savePath.create(recursive: true);
    }

    final taskId = await FlutterDownloader.enqueue(
      url: session.videoUrl,
      savedDir: savePath.path,
      fileName: 'video.mp4',
      showNotification: true,
      openFileFromNotification: true,
    );

    return taskId;
  }

  Future<String?> getLocalPath(String sessionId) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/sessions/$sessionId/video.mp4');
    
    if (await file.exists()) {
      return file.path;
    }
    return null;
  }

  Future<void> removeDownloadedSession(String sessionId) async {
    final directory = await getApplicationDocumentsDirectory();
    final dir = Directory('${directory.path}/sessions/$sessionId');
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }
}
