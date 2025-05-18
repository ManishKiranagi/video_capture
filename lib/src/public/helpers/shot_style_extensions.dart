import 'package:video_capture/src/helpers/shot_style_labels.dart';
import 'package:video_capture/src/public/model/shot_style.dart';

extension ShotStyleDisplay on ShotStyle {
  String get displayName {
    switch (this) {
      case ShotStyle.walkthrough:
        return walkthroughDisplayName;
      case ShotStyle.cinematic:
        return cinematicDisplayName;
    }
  }
}
