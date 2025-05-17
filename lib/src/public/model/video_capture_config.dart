import 'package:flutter/material.dart';
import 'package:video_capture/src/public/model/scene_capture_request.dart';
import 'package:video_capture/src/public/model/video_clip_result.dart';

class VideoCaptureConfig {
  final List<SceneCaptureRequest>? clipRequests;
  final List<VideoClipResult>? completedClips;
  final ThemeData? theme;
  final Function(VideoClipResult result)? onClipComplete;
  final Function()? onFlowComplete;
  final Function(List<SceneCaptureRequest> sceneTypes)? onSceneTypesSelected;

  const VideoCaptureConfig(
      {this.theme,
      this.onClipComplete,
      this.onFlowComplete,
      this.clipRequests,
      this.onSceneTypesSelected,
      this.completedClips});
}
