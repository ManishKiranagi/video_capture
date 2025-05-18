// test/helpers/scene_type_extensions_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:video_capture/src/helpers/scene_type_labels.dart';
import 'package:video_capture/src/public/helpers/scene_type_extensions.dart';
import 'package:video_capture/src/public/model/scene_type.dart';

void main() {
  group('SceneTypeExtensions.displayName', () {
    test('returns correct name for frontOfProperty', () {
      expect(SceneType.frontOfProperty.displayName, frontOfPropertyDisplayName);
    });

    test('returns correct name for entranceHall', () {
      expect(SceneType.entranceHall.displayName, entranceHallDisplayName);
    });

    test('returns correct name for receptionRoom', () {
      expect(SceneType.receptionRoom.displayName, receptionRoomDisplayName);
    });

    test('returns correct name for kitchen', () {
      expect(SceneType.kitchen.displayName, kitchenDisplayName);
    });

    test('returns correct name for diningRoom', () {
      expect(SceneType.diningRoom.displayName, diningRoomDisplayName);
    });

    test('returns correct name for conservatory', () {
      expect(SceneType.conservatory.displayName, conservatoryDisplayName);
    });

    test('returns correct name for bedroom', () {
      expect(SceneType.bedroom.displayName, bedroomDisplayName);
    });

    test('returns correct name for bathroom', () {
      expect(SceneType.bathroom.displayName, bathroomDisplayName);
    });

    test('returns correct name for garden', () {
      expect(SceneType.garden.displayName, gardenDisplayName);
    });

    test('returns correct name for terrace', () {
      expect(SceneType.terrace.displayName, terraceDisplayName);
    });
  });
}
