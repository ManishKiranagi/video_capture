import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_capture/src/helpers/wrapper.dart';
import 'package:video_capture/src/internal/video_capture/model/video_capture_stage.dart';
import 'package:video_capture/src/public/model/clip_orientation.dart';
import 'package:video_capture/src/public/model/scene_capture_request.dart';
import 'package:video_capture/src/public/model/scene_type.dart';
import 'package:video_capture/src/public/model/shot_style.dart';
import 'package:video_capture/src/public/model/video_clip_result.dart';

part 'video_capture_event.dart';
part 'video_capture_state.dart';

class VideoCaptureFlowBloc extends Bloc<VideoCaptureFlowEvent, VideoCaptureFlowState> {
  VideoCaptureFlowBloc(
      {required List<SceneCaptureRequest> requiredScenes,
      List<VideoClipResult>? completedClips,
      required Orientation currentOrientation})
      : assert(requiredScenes.isNotEmpty, 'requiredScenes must not be empty'),
        super(VideoCaptureFlowState.initial(
          requiredScenes: requiredScenes,
          completedClips: completedClips,
          currentOrientation: currentOrientation,
        )) {
    on<VideoCaptureFlowOrientationChanged>(_onVideoCaptureFlowOrientationChanged);
    on<VideoCaptureFlowFilmingProcessStarted>(_onVideoCaptureFlowFilmingProcessStarted);
    on<VideoCaptureFlowShotStyleSelected>(_onVideoCaptureFlowShotStyleSelected);
    on<VideoCaptureFlowFilmingStarted>(_onVideoCaptureFlowFilmingStarted);
    on<VideoCaptureFlowFilmingFinished>(_onVideoCaptureFlowFilmingFinished);
    on<VideoCaptureFlowShotApproved>(_onVideoCaptureFlowShotApproved);
  }

  void _onVideoCaptureFlowOrientationChanged(
      VideoCaptureFlowOrientationChanged event, Emitter<VideoCaptureFlowState> emit) {
    final isOrientationCorrect = state.requiredOrientation == event.orientation;
    var currentStage = state.stage;
    var previousStage = state.previousStage;

    if (state.stage == VideoCaptureStage.orientationMessaging && isOrientationCorrect) {
      previousStage = VideoCaptureStage.orientationMessaging;
      currentStage = VideoCaptureStage.videoCaptureGuidance;
    }
    if (state.stage == VideoCaptureStage.recording && isOrientationCorrect) {
      previousStage = VideoCaptureStage.recording;
      currentStage = VideoCaptureStage.shotTypeSelection;
    }

    emit(state.copyWith(isOrientationCorrect: isOrientationCorrect, stage: currentStage, previousStage: previousStage));
  }

  void _onVideoCaptureFlowFilmingProcessStarted(
      VideoCaptureFlowFilmingProcessStarted event, Emitter<VideoCaptureFlowState> emit) {
    emit(_updateVideoCaptureStage(state, VideoCaptureStage.shotTypeSelection));
  }

  void _onVideoCaptureFlowShotStyleSelected(
      VideoCaptureFlowShotStyleSelected event, Emitter<VideoCaptureFlowState> emit) {
    emit(state.copyWith(selectedShotStyle: event.shotStyle));
  }

  void _onVideoCaptureFlowFilmingStarted(VideoCaptureFlowFilmingStarted event, Emitter<VideoCaptureFlowState> emit) {
    emit(_updateVideoCaptureStage(state, VideoCaptureStage.recording));
  }

  void _onVideoCaptureFlowFilmingFinished(VideoCaptureFlowFilmingFinished event, Emitter<VideoCaptureFlowState> emit) {
    final clipResult = VideoClipResult(
        sceneType: state.currentScene,
        filePath: event.videoFilePath,
        orientation:
            state.requiredOrientation == Orientation.landscape ? ClipOrientation.landscape : ClipOrientation.portrait,
        shotStyle: state.selectedShotStyle!);

    emit(_updateVideoCaptureStage(state, VideoCaptureStage.approval).copyWith(videoClip: Wrapped.value(clipResult)));
  }

  void _onVideoCaptureFlowShotApproved(VideoCaptureFlowShotApproved event, Emitter<VideoCaptureFlowState> emit) {
    //copy clip result to completed clips

    //check next clip
    //if all clips completed
    //next stage is completion
    //if not all complete
    //reset state
    //move to orientation message

    //how does UI call onClipComplete and onFlowComplete
  }

  VideoCaptureFlowState _updateVideoCaptureStage(VideoCaptureFlowState state, VideoCaptureStage currentStage) {
    return state.copyWith(previousStage: state.stage, stage: currentStage);
  }
}
