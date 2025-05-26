import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:video_capture/src/internal/video_capture/bloc/video_capture_bloc.dart';
import 'package:video_capture/src/internal/video_capture/helpers/video_capture_flow_state_extensions.dart';
import 'package:video_capture/src/internal/video_capture/model/video_capture_stage.dart';
import 'package:video_capture/src/public/model/clip_orientation.dart';
import 'package:video_capture/src/public/model/scene_capture_request.dart';
import 'package:video_capture/src/public/model/scene_type.dart';
import 'package:video_capture/src/public/model/shot_style.dart';
import 'package:video_capture/src/public/model/video_clip_result.dart';

void main() {
  group('VideoCaptureFlowStateExtensions', () {
    const scene1 = SceneCaptureRequest(SceneType.kitchen, 'scene_1');

    const dummyClip = VideoClipResult(
      sceneType: SceneType.kitchen,
      sceneId: 'scene_1',
      filePath: 'path/to/video.mp4',
      orientation: ClipOrientation.landscape,
      shotStyle: ShotStyle.walkthrough,
    );

    const baseState = VideoCaptureFlowState(
      requiredScenes: [scene1],
      completedClips: [dummyClip],
      stage: VideoCaptureStage.orientationMessaging,
      previousStage: VideoCaptureStage.approval,
      currentScene: scene1,
      requiredOrientation: Orientation.portrait,
      isOrientationCorrect: false,
    );

    test('hasReturnedFromApproval returns true correctly', () {
      expect(baseState.hasReturnedFromApproval, isTrue);
    });

    test('hasCompletedFinalClip returns false when stage is not completion', () {
      expect(baseState.hasCompletedFinalClip, isFalse);
    });

    test('hasCompletedFinalClip returns true when stage is completion', () {
      final hasCompletedFinalClipState = baseState.copyWith(stage: VideoCaptureStage.completion);
      expect(hasCompletedFinalClipState.hasCompletedFinalClip, isTrue);
    });

    test('lastApprovedClip returns the last clip if transition matches', () {
      expect(baseState.lastApprovedClip, dummyClip);
    });

    test('lastApprovedClip returns null if no clips', () {
      final noClipState = baseState.copyWith(completedClips: []);
      expect(noClipState.lastApprovedClip, isNull);
    });

    test('lastApprovedClip returns null if no matching transition', () {
      final notApprovedState = baseState.copyWith(
        previousStage: VideoCaptureStage.shotTypeSelection,
      );
      expect(notApprovedState.lastApprovedClip, isNull);
    });
  });
}
