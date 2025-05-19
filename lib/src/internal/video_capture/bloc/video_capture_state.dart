part of 'video_capture_bloc.dart';

class VideoCaptureFlowState extends Equatable {
  final List<SceneCaptureRequest> requiredScenes;
  final List<VideoClipResult> completedClips;

  final VideoCaptureStage stage;

  final SceneType currentScene;
  final Orientation requiredOrientation;
  final ShotStyle? selectedShotStyle;

  final bool isOrientationCorrect;

  const VideoCaptureFlowState(
      {required this.requiredScenes,
      required this.completedClips,
      required this.stage,
      required this.currentScene,
      required this.requiredOrientation,
      this.selectedShotStyle,
      required this.isOrientationCorrect});

  VideoCaptureFlowState copyWith({
    List<VideoClipResult>? completedClips,
    VideoCaptureStage? stage,
    SceneType? currentScene,
    Orientation? requiredOrientation,
    ShotStyle? selectedShotStyle,
    bool? isOrientationCorrect,
  }) {
    return VideoCaptureFlowState(
      requiredScenes: requiredScenes,
      completedClips: completedClips ?? this.completedClips,
      stage: stage ?? this.stage,
      currentScene: currentScene ?? this.currentScene,
      requiredOrientation: requiredOrientation ?? this.requiredOrientation,
      selectedShotStyle: selectedShotStyle ?? this.selectedShotStyle,
      isOrientationCorrect: isOrientationCorrect ?? this.isOrientationCorrect,
    );
  }

  factory VideoCaptureFlowState.initial({
    required List<SceneCaptureRequest> requiredScenes,
    required Orientation currentOrientation,
    List<VideoClipResult>? completedClips,
  }) {
    if (requiredScenes.isEmpty) {
      throw ArgumentError('requiredScenes cannot be empty');
    }

    return VideoCaptureFlowState(
      requiredScenes: requiredScenes,
      completedClips: completedClips ?? [],
      stage: VideoCaptureStage.orientationMessaging,
      currentScene: requiredScenes[0].sceneType,
      requiredOrientation: Orientation.landscape,
      isOrientationCorrect: currentOrientation == Orientation.landscape,
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
        isOrientationCorrect
      ];
}
