// File: lib/src/internal/extensions/scene_type_extensions.dart
import 'package:video_capture/src/internal/video_capture/model/shot_style_config.dart';
import 'package:video_capture/src/public/model/scene_type.dart';
import 'package:video_capture/src/public/model/shot_style.dart';

//TODO Add the shot style video urls

extension SceneTypeShotStyles on SceneType {
  List<SceneShotStyleConfig> get supportedShotStyles {
    switch (this) {
      case SceneType.frontOfProperty:
        return [
          const SceneShotStyleConfig(style: ShotStyle.cinematic, exampleVideoUrl: ''),
          const SceneShotStyleConfig(style: ShotStyle.walkthrough, exampleVideoUrl: ''),
        ];
      case SceneType.entranceHall:
        return [];
      case SceneType.receptionRoom:
        return [];
      case SceneType.kitchen:
        return [];
      case SceneType.diningRoom:
        return [];
      case SceneType.conservatory:
        return [];
      case SceneType.bedroom:
        return [];
      case SceneType.bathroom:
        return [];
      case SceneType.garden:
        return [];
      case SceneType.terrace:
        return [];
    }
  }
}
