import 'package:video_capture/src/public/model/scene_type.dart';

class SceneCaptureRequest {
  final SceneType sceneType;

  /// Number of logical recordings to perform for this scene type.
  /// Each recording will include both portrait and landscape orientation.
  final int recordingsCount;

  const SceneCaptureRequest(this.sceneType, this.recordingsCount);
}
