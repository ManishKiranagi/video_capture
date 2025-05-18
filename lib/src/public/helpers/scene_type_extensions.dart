import 'package:video_capture/src/helpers/scene_type_labels.dart';
import 'package:video_capture/src/public/model/scene_type.dart';

extension SceneTypeDisplay on SceneType {
  String get displayName {
    switch (this) {
      case SceneType.frontOfProperty:
        return frontOfPropertyDisplayName;
      case SceneType.entranceHall:
        return entranceHallDisplayName;
      case SceneType.receptionRoom:
        return receptionRoomDisplayName;
      case SceneType.kitchen:
        return kitchenDisplayName;
      case SceneType.bedroom:
        return bedroomDisplayName;
      case SceneType.bathroom:
        return bathroomDisplayName;
      case SceneType.garden:
        return gardenDisplayName;
    }
  }
}
