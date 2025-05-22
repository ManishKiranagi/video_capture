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

  const VideoCaptureFlowState(
      {required this.requiredScenes,
      required this.completedClips,
      required this.stage,
      this.currentScene,
      this.requiredOrientation,
      this.selectedShotStyle,
      required this.isOrientationCorrect,
      this.videoClip,
      this.previousStage});

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

  factory VideoCaptureFlowState.initial({
    required List<SceneCaptureRequest> requiredScenes,
    required Orientation currentOrientation,
    List<VideoClipResult>? completedClips,
  }) {
    if (requiredScenes.isEmpty) {
      throw ArgumentError('requiredScenes cannot be empty');
    }

    final completed = completedClips ?? [];

    final nextScene = requiredScenes.firstWhere(
      (scene) => !isSceneComplete(scene, completed),
      orElse: () => throw StateError('All required scenes are already completed'),
    );

    final requiredOrientation = VideoCaptureFlowState.determineNextRequiredOrientation(
      scene: nextScene,
      completedClips: completed,
    );

    return VideoCaptureFlowState(
      requiredScenes: requiredScenes,
      completedClips: completed,
      stage: VideoCaptureStage.orientationMessaging,
      currentScene: nextScene,
      requiredOrientation: requiredOrientation,
      isOrientationCorrect: currentOrientation == requiredOrientation,
    );
  }

  static bool isSceneComplete(SceneCaptureRequest scene, List<VideoClipResult> completedClips) {
    final clipsForScene =
        completedClips.where((clip) => clip.sceneId == scene.sceneId && clip.sceneType == scene.sceneType);
    final hasPortrait = clipsForScene.any((clip) => clip.orientation == ClipOrientation.portrait);
    final hasLandscape = clipsForScene.any((clip) => clip.orientation == ClipOrientation.landscape);
    return hasPortrait && hasLandscape;
  }

  static Orientation determineNextRequiredOrientation({
    required SceneCaptureRequest scene,
    required List<VideoClipResult> completedClips,
  }) {
    final orientationsCompleted = completedClips
        .where((clip) => clip.sceneId == scene.sceneId && clip.sceneType == scene.sceneType)
        .map((clip) => clip.orientation)
        .toSet();

    if (!orientationsCompleted.contains(ClipOrientation.landscape)) {
      return Orientation.landscape;
    }

    if (!orientationsCompleted.contains(ClipOrientation.portrait)) {
      return Orientation.portrait;
    }

    throw StateError('All orientations already completed for sceneId: ${scene.sceneId}');
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
