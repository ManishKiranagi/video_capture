import 'package:flutter/material.dart';
import 'package:video_capture/src/public/model/scene_capture_request.dart';
import 'package:video_capture/src/public/model/video_capture_config.dart';

class SceneTypeSelectionScreen extends StatelessWidget {
  final VideoCaptureConfig videoCaptureConfig;
  final void Function(List<SceneCaptureRequest> selectedSceneTypes) onSceneTypesConfirmed;
  const SceneTypeSelectionScreen({super.key, required this.onSceneTypesConfirmed, required this.videoCaptureConfig});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
