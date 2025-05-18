import 'package:flutter/material.dart';
import 'package:video_capture/src/public/model/scene_capture_request.dart';
import 'package:video_capture/src/public/model/video_clip_result.dart';

class VideoCaptureConfig {
  final ThemeData? theme;
  final void Function(VideoClipResult result)? onClipComplete;
  final void Function()? onFlowComplete;
  final void Function(List<SceneCaptureRequest> sceneTypes)? onSceneTypesSelected;
  final void Function() onFlowCancelled;

  const VideoCaptureConfig(
      {this.theme, this.onClipComplete, this.onFlowComplete, this.onSceneTypesSelected, required this.onFlowCancelled});
}
