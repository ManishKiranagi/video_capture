part of 'video_capture_bloc.dart';

abstract class VideoCaptureFlowEvent extends Equatable {}

class VideoCaptureFlowOrientationChanged extends VideoCaptureFlowEvent {
  final DeviceOrientation orientation;

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

class VideoCaptureFlowShotApproved extends VideoCaptureFlowEvent {
  final String videoFilePath;
  VideoCaptureFlowShotApproved({required this.videoFilePath});

  @override
  List<Object> get props => [videoFilePath];
}
