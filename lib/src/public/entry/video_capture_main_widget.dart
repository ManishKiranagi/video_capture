import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_capture/src/internal/scene_type_selection/ui/scene_type_selection_screen.dart';
import 'package:video_capture/src/internal/scene_type_selection_flow/bloc/scene_type_selection_flow_bloc.dart';
import 'package:video_capture/src/internal/video_capture/ui/video_capture_flow_widget.dart';
import 'package:video_capture/src/public/model/scene_capture_request.dart';
import 'package:video_capture/src/public/model/video_capture_config.dart';
import 'package:video_capture/src/public/model/video_clip_result.dart';

class VideoCaptureMainWidget extends StatelessWidget {
  final VideoCaptureConfig config;
  final List<SceneCaptureRequest>? selectedSceneTypes;
  final List<VideoClipResult>? completedClips;

  const VideoCaptureMainWidget({required this.config, super.key, this.selectedSceneTypes, this.completedClips});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SceneTypeSelectionFlowBloc(selectedSceneTypes: selectedSceneTypes),
      child: BlocConsumer<SceneTypeSelectionFlowBloc, SceneTypeSelectionFlowState>(
        listenWhen: (previous, current) => previous is SceneTypeSelectionState && current is CaptureFlowState,
        listener: (BuildContext context, SceneTypeSelectionFlowState state) {
          if (state is CaptureFlowState) {
            if (config.onSceneTypesSelected != null) {
              config.onSceneTypesSelected!(state.selectedScenes);
            }
          }
        },
        builder: (context, state) {
          if (state is SceneTypeSelectionState) {
            return SceneTypeSelectionScreen(
              onSceneTypesConfirmed: (selected) {
                context.read<SceneTypeSelectionFlowBloc>().add(SceneTypesSelected(selected));
              },
            );
          } else if (state is CaptureFlowState) {
            return VideoCaptureFlowWidget(
              config: config,
              selectedSceneTypes: state.selectedScenes,
              completedClips: completedClips,
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
