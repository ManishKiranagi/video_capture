part of 'video_capture_bloc.dart';

abstract class VideoCaptureFlowEvent {}

class InitializeCaptureFlow extends VideoCaptureFlowEvent {
  final List<ClipSpec> clipSpecs;
  InitializeCaptureFlow(this.clipSpecs);
}

class OrientationChanged extends VideoCaptureFlowEvent {
  final DeviceOrientation orientation;
  OrientationChanged(this.orientation);
}

class StartRecording extends VideoCaptureFlowEvent {}

class StopRecording extends VideoCaptureFlowEvent {
  final String filePath;
  StopRecording(this.filePath);
}

class ApproveRecording extends VideoCaptureFlowEvent {}
