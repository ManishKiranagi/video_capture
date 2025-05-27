import 'package:flutter/material.dart';
import 'package:video_capture/src/internal/scene_type_selection/ui/scene_type_selection_screen.dart';
import 'package:video_capture/src/internal/theme.dart';
import 'package:video_capture/src/internal/video_capture/ui/video_capture_flow_widget.dart';
import 'package:video_capture/src/public/model/scene_capture_request.dart';
import 'package:video_capture/src/public/model/video_capture_config.dart';
import 'package:video_capture/src/public/model/video_clip_result.dart';

class VideoCaptureMainWidget extends StatefulWidget {
  final VideoCaptureConfig config;
  final List<SceneCaptureRequest>? selectedSceneTypes;
  final List<VideoClipResult>? completedClips;

  const VideoCaptureMainWidget({super.key, required this.config, this.selectedSceneTypes, this.completedClips});

  @override
  State<VideoCaptureMainWidget> createState() => _VideoCaptureMainWidgetState();
}

class _VideoCaptureMainWidgetState extends State<VideoCaptureMainWidget> {
  List<SceneCaptureRequest>? _selectedScenes;

  void _handleSceneTypesSelected(List<SceneCaptureRequest> selected) {
    setState(() {
      _selectedScenes = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config;
    final theme = config.theme ?? videoCaptureDefaultTheme;

    return Theme(
        data: theme,
        child: Builder(
          builder: (context) {
            if (widget.selectedSceneTypes != null) {
              return VideoCaptureFlowWidget(
                config: config,
                selectedSceneTypes: widget.selectedSceneTypes!,
                completedClips: widget.completedClips,
              );
            }

            if (_selectedScenes != null) {
              return VideoCaptureFlowWidget(
                config: config,
                selectedSceneTypes: _selectedScenes!,
              );
            }

            return SceneTypeSelectionScreen(
              onSceneTypesConfirmed: _handleSceneTypesSelected,
              videoCaptureConfig: config,
            );
          },
        ));
  }
}
