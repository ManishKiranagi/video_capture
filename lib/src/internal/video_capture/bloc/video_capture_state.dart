part of 'video_capture_bloc.dart';

class VideoCaptureFlowState extends Equatable {
  final List<SceneCaptureRequest> requiredScenes;
  final List<VideoClipResult> completedClips;

  final VideoCaptureStage stage;
  final VideoCaptureStage? previousStage;

  final SceneCaptureRequest? currentScene;
  final Orientation? requiredOrientation;
  final ShotStyle? selectedShotStyle;

  final VideoClipResult? videoClip;

  final bool isOrientationCorrect;

  final String? errorMessage;

  const VideoCaptureFlowState(
      {required this.requiredScenes,
      required this.completedClips,
      required this.stage,
      this.currentScene,
      this.requiredOrientation,
      this.selectedShotStyle,
      required this.isOrientationCorrect,
      this.videoClip,
      this.previousStage,
      this.errorMessage});

  VideoCaptureFlowState copyWith(
      {List<VideoClipResult>? completedClips,
      VideoCaptureStage? stage,
      Wrapped<SceneCaptureRequest?>? currentScene,
      Wrapped<Orientation?>? requiredOrientation,
      Wrapped<ShotStyle?>? selectedShotStyle,
      bool? isOrientationCorrect,
      Wrapped<VideoClipResult?>? videoClip,
      VideoCaptureStage? previousStage}) {
    return VideoCaptureFlowState(
        requiredScenes: requiredScenes,
        completedClips: completedClips ?? this.completedClips,
        stage: stage ?? this.stage,
        currentScene: currentScene != null ? currentScene.value : this.currentScene,
        requiredOrientation: requiredOrientation != null ? requiredOrientation.value : this.requiredOrientation,
        selectedShotStyle: selectedShotStyle != null ? selectedShotStyle.value : this.selectedShotStyle,
        isOrientationCorrect: isOrientationCorrect ?? this.isOrientationCorrect,
        videoClip: videoClip != null ? videoClip.value : this.videoClip,
        previousStage: previousStage ?? this.previousStage);
  }

  factory VideoCaptureFlowState.empty() {
    return const VideoCaptureFlowState(
      requiredScenes: [],
      completedClips: [],
      stage: VideoCaptureStage.uninitialized,
      currentScene: null,
      requiredOrientation: null,
      selectedShotStyle: null,
      isOrientationCorrect: false,
      videoClip: null,
      previousStage: null,
    );
  }

  factory VideoCaptureFlowState.failure(String message) {
    return VideoCaptureFlowState(
      requiredScenes: const [],
      completedClips: const [],
      stage: VideoCaptureStage.error,
      isOrientationCorrect: false,
      errorMessage: message,
    );
  }

  @override
  List<Object?> get props => [
        requiredScenes,
        completedClips,
        stage,
        currentScene,
        requiredOrientation,
        selectedShotStyle,
        isOrientationCorrect,
        videoClip,
        previousStage,
        errorMessage
      ];
}
