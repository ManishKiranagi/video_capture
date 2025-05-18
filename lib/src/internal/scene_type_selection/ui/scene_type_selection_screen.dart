import 'package:flutter/material.dart';
import 'package:video_capture/src/public/model/scene_capture_request.dart';

class SceneTypeSelectionScreen extends StatelessWidget {
  final void Function(List<SceneCaptureRequest> selectedSceneTypes) onSceneTypesConfirmed;
  const SceneTypeSelectionScreen({super.key, required this.onSceneTypesConfirmed});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
