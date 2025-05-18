part of 'scene_type_selection_flow_bloc.dart';

sealed class SceneTypeSelectionFlowState extends Equatable {
  const SceneTypeSelectionFlowState();
}

class SceneTypeSelectionState extends SceneTypeSelectionFlowState {
  @override
  List<Object> get props => [];
}

class CaptureFlowState extends SceneTypeSelectionFlowState {
  final List<SceneCaptureRequest> selectedScenes;
  const CaptureFlowState(this.selectedScenes);

  @override
  List<Object?> get props => [selectedScenes];
}
