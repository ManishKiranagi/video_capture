import 'package:video_capture/src/internal/video_capture/bloc/video_capture_bloc.dart';
import 'package:video_capture/src/internal/video_capture/model/video_capture_stage.dart';
import 'package:video_capture/src/public/model/video_clip_result.dart';

extension VideoCaptureFlowStateExtensions on VideoCaptureFlowState {
  bool get hasReturnedFromApproval =>
      previousStage == VideoCaptureStage.approval && stage == VideoCaptureStage.orientationMessaging;

  bool get hasCompletedFinalClip =>
      previousStage == VideoCaptureStage.approval && stage == VideoCaptureStage.completion;

  VideoClipResult? get lastApprovedClip =>
      (hasReturnedFromApproval || hasCompletedFinalClip) && completedClips.isNotEmpty ? completedClips.last : null;
}
