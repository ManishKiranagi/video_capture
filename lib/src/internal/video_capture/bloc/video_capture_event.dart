part of 'video_capture_bloc.dart';

abstract class VideoCaptureFlowEvent extends Equatable {}

class VideoCaptureFlowStarted extends VideoCaptureFlowEvent {
  final List<SceneCaptureRequest> requiredScenes;
  final List<VideoClipResult>? completedClips;
  final Orientation currentOrientation;

  VideoCaptureFlowStarted({required this.requiredScenes, this.completedClips, required this.currentOrientation});
  @override
  List<Object?> get props => [requiredScenes, completedClips, currentOrientation];
}

class VideoCaptureFlowOrientationChanged extends VideoCaptureFlowEvent {
  final Orientation orientation;

  VideoCaptureFlowOrientationChanged({required this.orientation});

  @override
  List<Object> get props => [orientation];
}

class VideoCaptureFlowFilmingProcessStarted extends VideoCaptureFlowEvent {
  VideoCaptureFlowFilmingProcessStarted();

  @override
  List<Object> get props => [];
}

class VideoCaptureFlowShotStyleSelected extends VideoCaptureFlowEvent {
  final ShotStyle shotStyle;

  VideoCaptureFlowShotStyleSelected({required this.shotStyle});

  @override
  List<Object> get props => [shotStyle];
}

class VideoCaptureFlowFilmingStarted extends VideoCaptureFlowEvent {
  VideoCaptureFlowFilmingStarted();

  @override
  List<Object> get props => [];
}

class VideoCaptureFlowFilmingFinished extends VideoCaptureFlowEvent {
  final String videoFilePath;
  VideoCaptureFlowFilmingFinished(this.videoFilePath);

  @override
  List<Object> get props => [videoFilePath];
}

class VideoCaptureFlowShotApproved extends VideoCaptureFlowEvent {
  VideoCaptureFlowShotApproved();

  @override
  List<Object> get props => [];
}
