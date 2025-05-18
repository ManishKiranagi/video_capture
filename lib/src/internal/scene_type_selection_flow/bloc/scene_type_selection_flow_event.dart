part of 'scene_type_selection_flow_bloc.dart';

sealed class SceneTypeSelectionFlowEvent extends Equatable {
  const SceneTypeSelectionFlowEvent();
}

class SceneTypesSelected extends SceneTypeSelectionFlowEvent {
  final List<SceneCaptureRequest> selectedSceneTypes;
  const SceneTypesSelected(this.selectedSceneTypes);

  @override
  List<Object?> get props => [selectedSceneTypes];
}
