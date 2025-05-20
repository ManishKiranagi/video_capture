import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:video_capture/src/internal/video_capture/bloc/video_capture_bloc.dart';
import 'package:video_capture/src/internal/video_capture/model/video_capture_stage.dart';
import 'package:video_capture/src/public/model/clip_orientation.dart';
import 'package:video_capture/src/public/model/scene_capture_request.dart';
import 'package:video_capture/src/public/model/scene_type.dart';
import 'package:video_capture/src/public/model/shot_style.dart';
import 'package:video_capture/src/public/model/video_clip_result.dart';

void main() {
  const sampleScene = SceneCaptureRequest(SceneType.kitchen, 1);
  const sampleClip = VideoClipResult(
      filePath: 'path/to/video.mp4',
      sceneType: SceneType.kitchen,
      orientation: ClipOrientation.landscape,
      shotStyle: ShotStyle.walkthrough);

  group('VideoCaptureFlowState', () {
    test('constructor assigns values correctly', () {
      const state = VideoCaptureFlowState(
        requiredScenes: [sampleScene],
        completedClips: [sampleClip],
        stage: VideoCaptureStage.recording,
        currentScene: SceneType.kitchen,
        requiredOrientation: Orientation.landscape,
        selectedShotStyle: ShotStyle.cinematic,
        isOrientationCorrect: true,
        videoClip: sampleClip,
        previousStage: VideoCaptureStage.shotTypeSelection,
      );

      expect(state.requiredScenes, [sampleScene]);
      expect(state.completedClips, [sampleClip]);
      expect(state.stage, VideoCaptureStage.recording);
      expect(state.currentScene, SceneType.kitchen);
      expect(state.requiredOrientation, Orientation.landscape);
      expect(state.selectedShotStyle, ShotStyle.cinematic);
      expect(state.isOrientationCorrect, isTrue);
      expect(state.videoClip, sampleClip);
      expect(state.previousStage, VideoCaptureStage.shotTypeSelection);
    });

    test('copyWith copies and overrides fields correctly', () {
      const original = VideoCaptureFlowState(
        requiredScenes: [sampleScene],
        completedClips: [],
        stage: VideoCaptureStage.orientationMessaging,
        currentScene: SceneType.kitchen,
        requiredOrientation: Orientation.portrait,
        isOrientationCorrect: false,
      );

      final copy = original.copyWith(
        completedClips: [sampleClip],
        stage: VideoCaptureStage.recording,
        currentScene: SceneType.bathroom,
        requiredOrientation: Orientation.landscape,
        selectedShotStyle: ShotStyle.walkthrough,
        isOrientationCorrect: true,
        videoClip: sampleClip,
        previousStage: VideoCaptureStage.orientationMessaging,
      );

      expect(copy.requiredScenes, original.requiredScenes);
      expect(copy.completedClips, [sampleClip]);
      expect(copy.stage, VideoCaptureStage.recording);
      expect(copy.currentScene, SceneType.bathroom);
      expect(copy.requiredOrientation, Orientation.landscape);
      expect(copy.selectedShotStyle, ShotStyle.walkthrough);
      expect(copy.isOrientationCorrect, true);
      expect(copy.videoClip, sampleClip);
      expect(copy.previousStage, VideoCaptureStage.orientationMessaging);
    });

    test('initial factory returns proper initial state (orientation landscape)', () {
      final requiredScenes = [
        const SceneCaptureRequest(SceneType.kitchen, 1),
        const SceneCaptureRequest(SceneType.bedroom, 1),
      ];

      final state = VideoCaptureFlowState.initial(
        requiredScenes: requiredScenes,
        currentOrientation: Orientation.landscape,
      );

      expectInitialState(state, requiredScenes, true);
    });

    test('initial factory returns proper initial state (orientation portrait)', () {
      final requiredScenes = [
        const SceneCaptureRequest(SceneType.kitchen, 1),
        const SceneCaptureRequest(SceneType.bedroom, 1),
      ];

      final state = VideoCaptureFlowState.initial(
        requiredScenes: requiredScenes,
        currentOrientation: Orientation.portrait,
      );

      expectInitialState(state, requiredScenes, false);
    });

    test('initial factory throws error when requiredScenes is empty', () {
      expect(() => VideoCaptureFlowState.initial(requiredScenes: const [], currentOrientation: Orientation.landscape),
          throwsA(isA<ArgumentError>()));
    });

    test('equality depends on props', () {
      const a = VideoCaptureFlowState(
        requiredScenes: [sampleScene],
        completedClips: [],
        stage: VideoCaptureStage.orientationMessaging,
        currentScene: SceneType.kitchen,
        requiredOrientation: Orientation.landscape,
        isOrientationCorrect: true,
      );

      const b = VideoCaptureFlowState(
        requiredScenes: [sampleScene],
        completedClips: [],
        stage: VideoCaptureStage.orientationMessaging,
        currentScene: SceneType.kitchen,
        requiredOrientation: Orientation.landscape,
        isOrientationCorrect: true,
      );

      final c = b.copyWith(stage: VideoCaptureStage.recording);

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(a == c, isFalse);
    });
  });
}

void expectInitialState(
    VideoCaptureFlowState state, List<SceneCaptureRequest> requiredScenes, bool isOrientationCorrect) {
  expect(state.requiredScenes, requiredScenes);
  expect(state.completedClips, isEmpty);
  expect(state.stage, VideoCaptureStage.orientationMessaging);
  expect(state.currentScene, requiredScenes[0].sceneType);
  expect(state.requiredOrientation, Orientation.landscape);
  expect(state.isOrientationCorrect, isOrientationCorrect);
  expect(state.selectedShotStyle, isNull);
  expect(state.videoClip, isNull);
  expect(state.previousStage, isNull);
}
