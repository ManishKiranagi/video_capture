import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_capture/src/public/model/scene_capture_request.dart';

part 'scene_type_selection_flow_event.dart';
part 'scene_type_selection_flow_state.dart';

class SceneTypeSelectionFlowBloc extends Bloc<SceneTypeSelectionFlowEvent, SceneTypeSelectionFlowState> {
  SceneTypeSelectionFlowBloc({List<SceneCaptureRequest>? selectedSceneTypes})
      : super(selectedSceneTypes == null ? SceneTypeSelectionState() : CaptureFlowState(selectedSceneTypes)) {
    on<SceneTypesSelected>(_onSceneTypesSelected);
  }

  void _onSceneTypesSelected(SceneTypesSelected event, Emitter<SceneTypeSelectionFlowState> emit) {
    emit(CaptureFlowState(event.selectedSceneTypes));
  }
}
