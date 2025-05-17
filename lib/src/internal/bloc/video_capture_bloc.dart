import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

part 'video_capture_event.dart';
part 'video_capture_state.dart';

class VideoCaptureFlowBloc extends Bloc<VideoCaptureFlowEvent, VideoCaptureFlowState> {
  VideoCaptureFlowBloc()
      : super(const VideoCaptureFlowState(
          remainingClips: [],
          currentClip: null,
          stage: VideoCaptureStage.messaging,
          deviceOrientation: DeviceOrientation.portraitUp,
          isOrientationCorrect: false,
          isRecording: false,
          recordedClips: [],
        )) {
    on<InitializeCaptureFlow>(_onInit);
    on<OrientationChanged>(_onOrientationChanged);
    on<StartRecording>(_onStartRecording);
    on<StopRecording>(_onStopRecording);
    on<ApproveRecording>(_onApprove);
  }

  void _onInit(InitializeCaptureFlow event, Emitter emit) {
    final initial = event.clipSpecs.first;
    emit(state.copyWith(
      remainingClips: event.clipSpecs.sublist(1),
      currentClip: initial,
      stage: VideoCaptureStage.messaging,
      isOrientationCorrect: false,
    ));
  }

  void _onOrientationChanged(OrientationChanged event, Emitter emit) {
    final correct = state.currentClip?.requiredOrientation == event.orientation;
    emit(state.copyWith(
      deviceOrientation: event.orientation,
      isOrientationCorrect: correct,
    ));
  }

  void _onStartRecording(StartRecording event, Emitter emit) {
    if (!state.isOrientationCorrect || state.isRecording) return;
    emit(state.copyWith(
      isRecording: true,
      stage: VideoCaptureStage.recording,
    ));
  }

  void _onStopRecording(StopRecording event, Emitter emit) {
    final recorded = RecordedClip(spec: state.currentClip!, filePath: event.filePath);
    emit(state.copyWith(
      recordedClips: [...state.recordedClips, recorded],
      isRecording: false,
      stage: VideoCaptureStage.approval,
    ));
  }

  void _onApprove(ApproveRecording event, Emitter emit) {
    final nextClip = state.remainingClips.isNotEmpty ? state.remainingClips.first : null;
    final remaining = state.remainingClips.skip(1).toList();

    emit(state.copyWith(
      currentClip: nextClip,
      remainingClips: remaining,
      stage: nextClip != null ? VideoCaptureStage.messaging : VideoCaptureStage.completed,
    ));
  }
}
