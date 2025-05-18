part of 'video_capture_bloc.dart';

enum VideoCaptureStage {
  messaging,
  guidance,
  shotTypeSelection,
  recording,
  approval,
  completed,
}

class ClipSpec {
  final String sceneType;
  final DeviceOrientation requiredOrientation;

  ClipSpec({required this.sceneType, required this.requiredOrientation});
}

class RecordedClip {
  final ClipSpec spec;
  final String filePath;

  RecordedClip({required this.spec, required this.filePath});
}

class VideoCaptureFlowState {
  final List<ClipSpec> remainingClips;
  final ClipSpec? currentClip;
  final VideoCaptureStage stage;
  final DeviceOrientation deviceOrientation;
  final bool isOrientationCorrect;
  final bool isRecording;
  final List<RecordedClip> recordedClips;

  bool get isCompleted => remainingClips.isEmpty;

  const VideoCaptureFlowState({
    required this.remainingClips,
    required this.currentClip,
    required this.stage,
    required this.deviceOrientation,
    required this.isOrientationCorrect,
    required this.isRecording,
    required this.recordedClips,
  });

  VideoCaptureFlowState copyWith({
    List<ClipSpec>? remainingClips,
    ClipSpec? currentClip,
    VideoCaptureStage? stage,
    DeviceOrientation? deviceOrientation,
    bool? isOrientationCorrect,
    bool? isRecording,
    List<RecordedClip>? recordedClips,
  }) {
    return VideoCaptureFlowState(
      remainingClips: remainingClips ?? this.remainingClips,
      currentClip: currentClip ?? this.currentClip,
      stage: stage ?? this.stage,
      deviceOrientation: deviceOrientation ?? this.deviceOrientation,
      isOrientationCorrect: isOrientationCorrect ?? this.isOrientationCorrect,
      isRecording: isRecording ?? this.isRecording,
      recordedClips: recordedClips ?? this.recordedClips,
    );
  }
}
