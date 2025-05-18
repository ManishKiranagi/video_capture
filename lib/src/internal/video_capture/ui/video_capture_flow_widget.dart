import 'package:flutter/material.dart';
import 'package:video_capture/video_capture_package.dart';

class VideoCaptureFlowWidget extends StatelessWidget {
  final VideoCaptureConfig config;
  final List<SceneCaptureRequest>? selectedSceneTypes;
  final List<VideoClipResult>? completedClips;
  const VideoCaptureFlowWidget({super.key, required this.config, this.selectedSceneTypes, this.completedClips});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
