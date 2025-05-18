import 'package:flutter/material.dart';
import 'package:video_capture/src/public/model/scene_capture_request.dart';
import 'package:video_capture/src/public/model/video_clip_result.dart';

class VideoCaptureConfig {
  final List<SceneCaptureRequest>? sceneCaptureRequests;
  final List<VideoClipResult>? completedClips;
  final ThemeData? theme;
  final Function(VideoClipResult result)? onClipComplete;
  final Function()? onFlowComplete;
  final Function(List<SceneCaptureRequest> sceneTypes)? onSceneTypesSelected;
  final Function() onFlowCancelled;

  const VideoCaptureConfig(
      {this.theme,
      this.onClipComplete,
      this.onFlowComplete,
      this.sceneCaptureRequests,
      this.onSceneTypesSelected,
      this.completedClips,
      required this.onFlowCancelled});
}
