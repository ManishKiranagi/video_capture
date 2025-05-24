import 'package:equatable/equatable.dart';
import 'package:video_capture/src/public/model/scene_type.dart';
import 'package:video_capture/src/public/model/shot_style.dart';
import 'package:video_capture/src/public/model/clip_orientation.dart';

class VideoClipResult extends Equatable {
  final SceneType sceneType;
  final String filePath;
  final ClipOrientation orientation;
  final ShotStyle shotStyle;
  final String sceneId;

  const VideoClipResult(
      {required this.sceneType,
      required this.filePath,
      required this.orientation,
      required this.shotStyle,
      required this.sceneId});

  @override
  List<Object?> get props => [sceneType, filePath, orientation, shotStyle, sceneId];
}
