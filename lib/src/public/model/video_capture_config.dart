import 'package:flutter/material.dart';
import 'package:video_capture/src/public/model/scene_capture_request.dart';
import 'package:video_capture/src/public/model/video_clip_result.dart';

class VideoCaptureConfig {
  final ThemeData? theme;
  final Future<void> Function(VideoClipResult result)? onClipComplete;
  final Future<void> Function()? onFlowComplete;
  final Future<void> Function(List<SceneCaptureRequest> sceneTypes)? onSceneTypesSelected;
  final Future<void> Function() onFlowCancelled;

  const VideoCaptureConfig(
      {this.theme, this.onClipComplete, this.onFlowComplete, this.onSceneTypesSelected, required this.onFlowCancelled});
}
