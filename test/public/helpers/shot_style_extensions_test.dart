import 'package:flutter_test/flutter_test.dart';
import 'package:video_capture/src/public/helpers/shot_style_extensions.dart';
import 'package:video_capture/src/public/model/shot_style.dart';
import 'package:video_capture/src/helpers/shot_style_labels.dart';

void main() {
  group('ShotStyleDisplay extension', () {
    test('walkthrough should return correct display name', () {
      expect(ShotStyle.walkthrough.displayName, walkthroughDisplayName);
    });

    test('cinematic should return correct display name', () {
      expect(ShotStyle.cinematic.displayName, cinematicDisplayName);
    });
  });
}
