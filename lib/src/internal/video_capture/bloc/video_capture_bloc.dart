import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:video_capture/src/internal/video_capture/model/video_capture_stage.dart';
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
    on<VideoCaptureFlowShotApproved>(_onVideoCaptureFlowShotApproved);
  }

  void _onVideoCaptureFlowOrientationChanged(
      VideoCaptureFlowOrientationChanged event, Emitter<VideoCaptureFlowState> emit) {}

  void _onVideoCaptureFlowFilmingProcessStarted(
      VideoCaptureFlowFilmingProcessStarted event, Emitter<VideoCaptureFlowState> emit) {}

  void _onVideoCaptureFlowShotStyleSelected(
      VideoCaptureFlowShotStyleSelected event, Emitter<VideoCaptureFlowState> emit) {}

  void _onVideoCaptureFlowFilmingStarted(VideoCaptureFlowFilmingStarted event, Emitter<VideoCaptureFlowState> emit) {}

  void _onVideoCaptureFlowShotApproved(VideoCaptureFlowShotApproved event, Emitter<VideoCaptureFlowState> emit) {}
}
