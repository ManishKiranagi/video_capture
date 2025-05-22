import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_capture/src/helpers/iterable_extension.dart';
import 'package:video_capture/src/helpers/wrapper.dart';
import 'package:video_capture/src/internal/video_capture/model/video_capture_stage.dart';
import 'package:video_capture/src/public/model/clip_orientation.dart';
import 'package:video_capture/src/public/model/scene_capture_request.dart';
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
    emit(state.copyWith(selectedShotStyle: Wrapped.value(event.shotStyle)));
  }

  void _onVideoCaptureFlowFilmingStarted(VideoCaptureFlowFilmingStarted event, Emitter<VideoCaptureFlowState> emit) {
    emit(_updateVideoCaptureStage(state, VideoCaptureStage.recording));
  }

  void _onVideoCaptureFlowFilmingFinished(VideoCaptureFlowFilmingFinished event, Emitter<VideoCaptureFlowState> emit) {
    final currentScene = state.currentScene!;
    final clipResult = VideoClipResult(
        sceneId: currentScene.sceneId,
        sceneType: currentScene.sceneType,
        filePath: event.videoFilePath,
        orientation:
            state.requiredOrientation == Orientation.landscape ? ClipOrientation.landscape : ClipOrientation.portrait,
        shotStyle: state.selectedShotStyle!);

    emit(_updateVideoCaptureStage(state, VideoCaptureStage.approval).copyWith(videoClip: Wrapped.value(clipResult)));
  }

  void _onVideoCaptureFlowShotApproved(VideoCaptureFlowShotApproved event, Emitter<VideoCaptureFlowState> emit) {
    final updatedClips = [...state.completedClips, state.videoClip!];

    final updatedState = state.copyWith(completedClips: updatedClips, videoClip: const Wrapped.value(null));

    final nextScene = _findNextIncompleteScene(updatedClips);

    if (nextScene == null) {
      emit(_transitionToCompletion(updatedState));
    } else {
      emit(_transitionToNextScene(updatedState, nextScene));
    }
  }

  // --- Private helper methods below ---

  VideoCaptureFlowState _transitionToCompletion(VideoCaptureFlowState state) {
    return _updateVideoCaptureStage(state, VideoCaptureStage.completion).copyWith(
      currentScene: const Wrapped.value(null),
      requiredOrientation: const Wrapped.value(null),
      selectedShotStyle: const Wrapped.value(null),
    );
  }

  VideoCaptureFlowState _transitionToNextScene(VideoCaptureFlowState state, SceneCaptureRequest nextScene) {
    final requiredOrientation = _toggleOrientation(state.requiredOrientation!);

    final selectedShotStyle =
        state.requiredOrientation == Orientation.landscape ? const Wrapped<ShotStyle?>.value(null) : null;

    return _updateVideoCaptureStage(state, VideoCaptureStage.orientationMessaging).copyWith(
      currentScene: Wrapped.value(nextScene),
      requiredOrientation: Wrapped.value(requiredOrientation),
      selectedShotStyle: selectedShotStyle,
    );
  }

  SceneCaptureRequest? _findNextIncompleteScene(List<VideoClipResult> completedClips) {
    return state.requiredScenes.firstWhereOrNull(
      (scene) => !VideoCaptureFlowState.isSceneComplete(scene, completedClips),
    );
  }

  VideoCaptureFlowState _updateVideoCaptureStage(VideoCaptureFlowState state, VideoCaptureStage currentStage) {
    return state.copyWith(previousStage: state.stage, stage: currentStage);
  }

  Orientation _toggleOrientation(Orientation current) {
    return current == Orientation.landscape ? Orientation.portrait : Orientation.landscape;
  }
}
