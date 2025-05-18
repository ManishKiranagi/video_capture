import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_capture/src/public/model/scene_capture_request.dart';
import 'package:video_capture/src/public/model/video_capture_config.dart';

part 'scene_type_selection_flow_event.dart';
part 'scene_type_selection_flow_state.dart';

class SceneTypeSelectionFlowBloc extends Bloc<SceneTypeSelectionFlowEvent, SceneTypeSelectionFlowState> {
  final VideoCaptureConfig config;

  SceneTypeSelectionFlowBloc({required this.config})
      : super(config.sceneCaptureRequests == null
            ? SceneTypeSelectionState()
            : CaptureFlowState(config.sceneCaptureRequests!)) {
    on<SceneTypesSelected>(_onSceneTypesSelected);
  }

  void _onSceneTypesSelected(SceneTypesSelected event, Emitter<SceneTypeSelectionFlowState> emit) {
    config.onSceneTypesSelected?.call(event.selectedSceneTypes);
    emit(CaptureFlowState(event.selectedSceneTypes));
  }
}
