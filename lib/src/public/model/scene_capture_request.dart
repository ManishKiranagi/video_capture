import 'package:video_capture/src/public/model/scene_type.dart';

class SceneCaptureRequest {
  final SceneType sceneType;

  final String sceneId;

  const SceneCaptureRequest(this.sceneType, this.sceneId);
}
