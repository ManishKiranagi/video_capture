import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:video_capture/src/helpers/wrapper.dart';
import 'package:video_capture/src/internal/video_capture/bloc/video_capture_bloc.dart';
import 'package:video_capture/src/internal/video_capture/model/video_capture_stage.dart';
import 'package:video_capture/src/public/model/clip_orientation.dart';
import 'package:video_capture/src/public/model/scene_capture_request.dart';
import 'package:video_capture/src/public/model/scene_type.dart';
import 'package:video_capture/src/public/model/shot_style.dart';
import 'package:video_capture/src/public/model/video_clip_result.dart';

void main() {
  const sceneId = 'kitchen_1';
  const sampleScene = SceneCaptureRequest(SceneType.kitchen, sceneId);
  const bathroomScene = SceneCaptureRequest(SceneType.bathroom, 'bathroom_1');
  const sampleClip = VideoClipResult(
      filePath: 'path/to/video.mp4',
      sceneType: SceneType.kitchen,
      orientation: ClipOrientation.landscape,
      shotStyle: ShotStyle.walkthrough,
      sceneId: sceneId);
  const clip1Portrait = VideoClipResult(
    sceneId: 'scene1',
    sceneType: SceneType.kitchen,
    filePath: '/path/clip1.mp4',
    orientation: ClipOrientation.portrait,
    shotStyle: ShotStyle.cinematic,
  );
  const clip1Landscape = VideoClipResult(
    sceneId: 'scene1',
    sceneType: SceneType.kitchen,
    filePath: '/path/clip2.mp4',
    orientation: ClipOrientation.landscape,
    shotStyle: ShotStyle.cinematic,
  );

  group('VideoCaptureFlowState', () {
    test('constructor assigns values correctly', () {
      const state = VideoCaptureFlowState(
        requiredScenes: [sampleScene],
        completedClips: [sampleClip],
        stage: VideoCaptureStage.recording,
        currentScene: sampleScene,
        requiredOrientation: Orientation.landscape,
        selectedShotStyle: ShotStyle.cinematic,
        isOrientationCorrect: true,
        videoClip: sampleClip,
        previousStage: VideoCaptureStage.shotTypeSelection,
      );

      expect(state.requiredScenes, [sampleScene]);
      expect(state.completedClips, [sampleClip]);
      expect(state.stage, VideoCaptureStage.recording);
      expect(state.currentScene, sampleScene);
      expect(state.requiredOrientation, Orientation.landscape);
      expect(state.selectedShotStyle, ShotStyle.cinematic);
      expect(state.isOrientationCorrect, isTrue);
      expect(state.videoClip, sampleClip);
      expect(state.previousStage, VideoCaptureStage.shotTypeSelection);
    });

    test('initial throws ArgumentError if requiredScenes is empty', () {
      expect(
        () => VideoCaptureFlowState.initial(
          requiredScenes: const [],
          currentOrientation: Orientation.landscape,
        ),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('requiredScenes cannot be empty'),
        )),
      );
    });

    test('copyWith copies and overrides fields correctly', () {
      const original = VideoCaptureFlowState(
        requiredScenes: [sampleScene],
        completedClips: [],
        stage: VideoCaptureStage.orientationMessaging,
        currentScene: sampleScene,
        requiredOrientation: Orientation.portrait,
        isOrientationCorrect: false,
      );

      final copy = original.copyWith(
        completedClips: [sampleClip],
        stage: VideoCaptureStage.recording,
        currentScene: const Wrapped.value(bathroomScene),
        requiredOrientation: const Wrapped.value(Orientation.landscape),
        selectedShotStyle: const Wrapped.value(ShotStyle.walkthrough),
        isOrientationCorrect: true,
        videoClip: const Wrapped.value(sampleClip),
        previousStage: VideoCaptureStage.orientationMessaging,
      );

      expect(copy.requiredScenes, original.requiredScenes);
      expect(copy.completedClips, [sampleClip]);
      expect(copy.stage, VideoCaptureStage.recording);
      expect(copy.currentScene, bathroomScene);
      expect(copy.requiredOrientation, Orientation.landscape);
      expect(copy.selectedShotStyle, ShotStyle.walkthrough);
      expect(copy.isOrientationCorrect, true);
      expect(copy.videoClip, sampleClip);
      expect(copy.previousStage, VideoCaptureStage.orientationMessaging);
    });

    test('initial factory returns proper initial state (orientation landscape)', () {
      final requiredScenes = [
        sampleScene,
        bathroomScene,
      ];

      final state = VideoCaptureFlowState.initial(
        requiredScenes: requiredScenes,
        currentOrientation: Orientation.landscape,
      );

      expectInitialState(state, requiredScenes, true);
    });

    test('initial factory returns proper initial state (orientation portrait)', () {
      final requiredScenes = [
        sampleScene,
        bathroomScene,
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

    test('initial throws StateError if all required scenes are already completed', () {
      const scene = SceneCaptureRequest(SceneType.kitchen, 'scene1');
      final completedClips = [
        clip1Portrait,
        clip1Landscape,
      ];

      expect(
        () => VideoCaptureFlowState.initial(
          requiredScenes: const [scene],
          completedClips: completedClips,
          currentOrientation: Orientation.portrait,
        ),
        throwsA(isA<StateError>().having(
          (e) => e.message,
          'message',
          contains('All required scenes are already completed'),
        )),
      );
    });

    test('isSceneComplete returns true if both orientations are present', () {
      final result = VideoCaptureFlowState.isSceneComplete(
          const SceneCaptureRequest(SceneType.kitchen, 'scene1'), [clip1Portrait, clip1Landscape]);
      expect(result, isTrue);
    });

    test('isSceneComplete returns false if only one orientation is present', () {
      final result = VideoCaptureFlowState.isSceneComplete(
          const SceneCaptureRequest(SceneType.kitchen, 'scene1'), [clip1Portrait]);
      expect(result, isFalse);
    });

    test('determineNextRequiredOrientation returns missing orientation', () {
      final result = VideoCaptureFlowState.determineNextRequiredOrientation(
        scene: const SceneCaptureRequest(SceneType.kitchen, 'scene1'),
        completedClips: [clip1Landscape],
      );
      expect(result, Orientation.portrait);
    });

    test('determineNextRequiredOrientation throws if all orientations are complete', () {
      expect(
        () => VideoCaptureFlowState.determineNextRequiredOrientation(
          scene: const SceneCaptureRequest(SceneType.kitchen, 'scene1'),
          completedClips: [clip1Portrait, clip1Landscape],
        ),
        throwsStateError,
      );
    });

    test('equality depends on props', () {
      const a = VideoCaptureFlowState(
        requiredScenes: [sampleScene],
        completedClips: [],
        stage: VideoCaptureStage.orientationMessaging,
        currentScene: sampleScene,
        requiredOrientation: Orientation.landscape,
        isOrientationCorrect: true,
      );

      const b = VideoCaptureFlowState(
        requiredScenes: [sampleScene],
        completedClips: [],
        stage: VideoCaptureStage.orientationMessaging,
        currentScene: sampleScene,
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
  expect(state.currentScene, requiredScenes[0]);
  expect(state.requiredOrientation, Orientation.landscape);
  expect(state.isOrientationCorrect, isOrientationCorrect);
  expect(state.selectedShotStyle, isNull);
  expect(state.videoClip, isNull);
  expect(state.previousStage, isNull);
}
