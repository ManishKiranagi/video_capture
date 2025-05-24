import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:video_capture/src/helpers/wrapper.dart';
import 'package:video_capture/src/internal/video_capture/bloc/video_capture_bloc.dart';
import 'package:video_capture/src/internal/video_capture/model/video_capture_stage.dart';
import 'package:video_capture/video_capture_package.dart';

void main() {
  group('VideoCaptureFlowBloc', () {
    late List<SceneCaptureRequest> requiredScenes;
    late List<VideoClipResult> completedClips;
    late VideoClipResult scene1portrait;
    late VideoClipResult scene1landscape;
    late VideoClipResult scene2portrait;
    late VideoClipResult scene2landscape;
    late SceneCaptureRequest scene1;
    late SceneCaptureRequest scene2;

    setUp(() {
      scene1 = const SceneCaptureRequest(SceneType.frontOfProperty, 'scene1');
      scene2 = const SceneCaptureRequest(SceneType.kitchen, 'scene2');
      requiredScenes = [
        scene1,
        scene2,
      ];
      scene1portrait = const VideoClipResult(
          filePath: 'scene1_portrait.mp4',
          sceneType: SceneType.frontOfProperty,
          sceneId: 'scene1',
          orientation: ClipOrientation.portrait,
          shotStyle: ShotStyle.walkthrough);
      scene1landscape = const VideoClipResult(
          filePath: 'scene1_landscape.mp4',
          sceneType: SceneType.frontOfProperty,
          sceneId: 'scene1',
          orientation: ClipOrientation.landscape,
          shotStyle: ShotStyle.walkthrough);
      scene2portrait = const VideoClipResult(
          filePath: 'scene2_portrait.mp4',
          sceneType: SceneType.kitchen,
          sceneId: 'scene2',
          orientation: ClipOrientation.portrait,
          shotStyle: ShotStyle.walkthrough);
      scene2landscape = const VideoClipResult(
          filePath: 'scene2_landscape.mp4',
          sceneType: SceneType.kitchen,
          sceneId: 'scene2',
          orientation: ClipOrientation.landscape,
          shotStyle: ShotStyle.walkthrough);
    });
    group('initial state tests', () {
      test('initial state is correct', () {
        final bloc = VideoCaptureFlowBloc();

        expect(bloc.state, VideoCaptureFlowState.empty());
      });
    });

    group('video capture flow started tests', () {
      blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
        'throws error if requiredScenes is empty',
        build: () => VideoCaptureFlowBloc(),
        act: (bloc) => bloc.add(
          VideoCaptureFlowStarted(requiredScenes: const [], currentOrientation: Orientation.portrait),
        ),
        expect: () => [
          isA<VideoCaptureFlowState>()
              .having((s) => s.stage, 'stage', VideoCaptureStage.error)
              .having((s) => s.errorMessage, 'errorMessage', 'requiredScenes cannot be empty'),
        ],
      );

      blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
        'throws error if completed clips contain all required scenes',
        build: () => VideoCaptureFlowBloc(),
        act: (bloc) {
          completedClips = [scene1landscape, scene1portrait, scene2landscape, scene2portrait];
          bloc.add(
            VideoCaptureFlowStarted(
                requiredScenes: requiredScenes,
                completedClips: completedClips,
                currentOrientation: Orientation.portrait),
          );
        },
        expect: () => [
          isA<VideoCaptureFlowState>()
              .having((s) => s.stage, 'stage', VideoCaptureStage.error)
              .having((s) => s.errorMessage, 'errorMessage', 'All required scenes are already completed'),
        ],
      );

      blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
        'returns state with correct stage, scene and required orientation when both orientations of a scene are present in completed clips and device orientation is portrait',
        build: () => VideoCaptureFlowBloc(),
        act: (bloc) {
          completedClips = [scene1landscape, scene1portrait];
          bloc.add(
            VideoCaptureFlowStarted(
                requiredScenes: requiredScenes,
                completedClips: completedClips,
                currentOrientation: Orientation.portrait),
          );
        },
        expect: () => [
          isA<VideoCaptureFlowState>()
              .having((s) => s.stage, 'stage', VideoCaptureStage.orientationMessaging)
              .having((s) => s.requiredScenes, 'requiredScenes', requiredScenes)
              .having((s) => s.completedClips, 'completedClips', completedClips)
              .having((s) => s.currentScene, 'currentScene', scene2)
              .having((s) => s.requiredOrientation, 'requiredOrientation', Orientation.landscape)
              .having((s) => s.isOrientationCorrect, 'isOrientationCorrect', false)
        ],
      );

      blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
        'returns state with correct stage, scene and required orientation when both orientations of a scene are present in completed clips and device orientation is landscape',
        build: () => VideoCaptureFlowBloc(),
        act: (bloc) {
          completedClips = [scene1landscape, scene1portrait];
          bloc.add(
            VideoCaptureFlowStarted(
                requiredScenes: requiredScenes,
                completedClips: completedClips,
                currentOrientation: Orientation.landscape),
          );
        },
        expect: () => [
          isA<VideoCaptureFlowState>()
              .having((s) => s.stage, 'stage', VideoCaptureStage.orientationMessaging)
              .having((s) => s.requiredScenes, 'requiredScenes', requiredScenes)
              .having((s) => s.completedClips, 'completedClips', completedClips)
              .having((s) => s.currentScene, 'currentScene', scene2)
              .having((s) => s.requiredOrientation, 'requiredOrientation', Orientation.landscape)
              .having((s) => s.isOrientationCorrect, 'isOrientationCorrect', true)
        ],
      );

      blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
        'returns state with correct stage, scene and required orientation when one orientation of a scene is present in completed clips and device orientation is landscape',
        build: () => VideoCaptureFlowBloc(),
        act: (bloc) {
          completedClips = [scene1landscape, scene1portrait, scene2landscape];
          bloc.add(
            VideoCaptureFlowStarted(
                requiredScenes: requiredScenes,
                completedClips: completedClips,
                currentOrientation: Orientation.landscape),
          );
        },
        expect: () => [
          isA<VideoCaptureFlowState>()
              .having((s) => s.stage, 'stage', VideoCaptureStage.orientationMessaging)
              .having((s) => s.requiredScenes, 'requiredScenes', requiredScenes)
              .having((s) => s.completedClips, 'completedClips', completedClips)
              .having((s) => s.currentScene, 'currentScene', scene2)
              .having((s) => s.requiredOrientation, 'requiredOrientation', Orientation.portrait)
              .having((s) => s.isOrientationCorrect, 'isOrientationCorrect', false)
        ],
      );

      blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
        'returns state with correct stage, scene and required orientation when one orientation of a scene is present in completed clips and device orientation is portrait',
        build: () => VideoCaptureFlowBloc(),
        act: (bloc) {
          completedClips = [scene1landscape, scene1portrait, scene2landscape];
          bloc.add(
            VideoCaptureFlowStarted(
                requiredScenes: requiredScenes,
                completedClips: completedClips,
                currentOrientation: Orientation.portrait),
          );
        },
        expect: () => [
          isA<VideoCaptureFlowState>()
              .having((s) => s.stage, 'stage', VideoCaptureStage.orientationMessaging)
              .having((s) => s.requiredScenes, 'requiredScenes', requiredScenes)
              .having((s) => s.completedClips, 'completedClips', completedClips)
              .having((s) => s.currentScene, 'currentScene', scene2)
              .having((s) => s.requiredOrientation, 'requiredOrientation', Orientation.portrait)
              .having((s) => s.isOrientationCorrect, 'isOrientationCorrect', true)
        ],
      );
    });

    group('orientation tests', () {
      blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
        'when orientationMessage stage and requiredOrientation is landscape and orientation set to landscape emits [videoCaptureGuidance]',
        build: () => VideoCaptureFlowBloc(),
        seed: () => VideoCaptureFlowState.empty().copyWith(
          stage: VideoCaptureStage.orientationMessaging,
          requiredOrientation: const Wrapped.value(Orientation.landscape),
        ),
        act: (bloc) => bloc.add(
          VideoCaptureFlowOrientationChanged(orientation: Orientation.landscape),
        ),
        expect: () => [
          isA<VideoCaptureFlowState>()
              .having((s) => s.stage, 'stage', VideoCaptureStage.videoCaptureGuidance)
              .having((s) => s.previousStage, 'previousStage', VideoCaptureStage.orientationMessaging)
              .having((s) => s.isOrientationCorrect, 'isOrientationCorrect', true),
        ],
      );

      blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
        'when orientationMessage stage and requiredOrientation is portrait and orientation set to landscape emits [orientationMessage]',
        build: () => VideoCaptureFlowBloc(),
        seed: () => VideoCaptureFlowState.empty().copyWith(
            stage: VideoCaptureStage.orientationMessaging,
            requiredOrientation: const Wrapped.value(Orientation.portrait),
            isOrientationCorrect: true),
        act: (bloc) => bloc.add(
          VideoCaptureFlowOrientationChanged(orientation: Orientation.landscape),
        ),
        expect: () => [
          isA<VideoCaptureFlowState>()
              .having((s) => s.stage, 'stage', VideoCaptureStage.orientationMessaging)
              .having((s) => s.previousStage, 'previousStage', null)
              .having((s) => s.isOrientationCorrect, 'isOrientationCorrect', false),
        ],
      );

      blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
        'when orientationMessage stage and requiredOrientation is landscape and orientation set to portrait emits [orientationMessage]',
        build: () => VideoCaptureFlowBloc(),
        seed: () => VideoCaptureFlowState.empty().copyWith(
            stage: VideoCaptureStage.orientationMessaging,
            requiredOrientation: const Wrapped.value(Orientation.landscape),
            isOrientationCorrect: true),
        act: (bloc) => bloc.add(
          VideoCaptureFlowOrientationChanged(orientation: Orientation.portrait),
        ),
        expect: () => [
          isA<VideoCaptureFlowState>()
              .having((s) => s.stage, 'stage', VideoCaptureStage.orientationMessaging)
              .having((s) => s.previousStage, 'previousStage', null)
              .having((s) => s.isOrientationCorrect, 'isOrientationCorrect', false),
        ],
      );

      blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
        'when orientationMessage stage and requiredOrientation is portrait and orientation set to portrait emits [videoCaptureGuidance]',
        build: () => VideoCaptureFlowBloc(),
        seed: () => VideoCaptureFlowState.empty().copyWith(
          stage: VideoCaptureStage.orientationMessaging,
          requiredOrientation: const Wrapped.value(Orientation.portrait),
        ),
        act: (bloc) => bloc.add(
          VideoCaptureFlowOrientationChanged(orientation: Orientation.portrait),
        ),
        expect: () => [
          isA<VideoCaptureFlowState>()
              .having((s) => s.stage, 'stage', VideoCaptureStage.videoCaptureGuidance)
              .having((s) => s.previousStage, 'previousStage', VideoCaptureStage.orientationMessaging)
              .having((s) => s.isOrientationCorrect, 'isOrientationCorrect', true),
        ],
      );

      blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
        'when recording stage and requiredOrientation is landscape and orientation set to landscape emits [shotTypeSelection]',
        build: () => VideoCaptureFlowBloc(),
        seed: () => VideoCaptureFlowState.empty().copyWith(
          stage: VideoCaptureStage.recording,
          requiredOrientation: const Wrapped.value(Orientation.landscape),
        ),
        act: (bloc) => bloc.add(
          VideoCaptureFlowOrientationChanged(orientation: Orientation.landscape),
        ),
        expect: () => [
          isA<VideoCaptureFlowState>()
              .having((s) => s.stage, 'stage', VideoCaptureStage.shotTypeSelection)
              .having((s) => s.previousStage, 'previousStage', VideoCaptureStage.recording)
              .having((s) => s.isOrientationCorrect, 'isOrientationCorrect', true),
        ],
      );

      blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
        'when recording stage and requiredOrientation is portrait and orientation set to portrait emits [shotTypeSelection]',
        build: () => VideoCaptureFlowBloc(),
        seed: () => VideoCaptureFlowState.empty().copyWith(
          stage: VideoCaptureStage.recording,
          requiredOrientation: const Wrapped.value(Orientation.portrait),
        ),
        act: (bloc) => bloc.add(
          VideoCaptureFlowOrientationChanged(orientation: Orientation.portrait),
        ),
        expect: () => [
          isA<VideoCaptureFlowState>()
              .having((s) => s.stage, 'stage', VideoCaptureStage.shotTypeSelection)
              .having((s) => s.previousStage, 'previousStage', VideoCaptureStage.recording)
              .having((s) => s.isOrientationCorrect, 'isOrientationCorrect', true),
        ],
      );

      blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
        'when videoCaptureGuidance stage and requiredOrientation is portrait and orientation set to landscape emits isOrientationCorrect as false',
        build: () => VideoCaptureFlowBloc(),
        seed: () => VideoCaptureFlowState.empty().copyWith(
            stage: VideoCaptureStage.videoCaptureGuidance,
            requiredOrientation: const Wrapped.value(Orientation.portrait),
            isOrientationCorrect: true),
        act: (bloc) => bloc.add(
          VideoCaptureFlowOrientationChanged(orientation: Orientation.landscape),
        ),
        expect: () => [
          isA<VideoCaptureFlowState>().having((s) => s.isOrientationCorrect, 'isOrientationCorrect', false),
        ],
      );
      blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
        'when videoCaptureGuidance stage and requiredOrientation is portrait and orientation set to portrait emits isOrientationCorrect as true',
        build: () => VideoCaptureFlowBloc(),
        seed: () => VideoCaptureFlowState.empty().copyWith(
            stage: VideoCaptureStage.videoCaptureGuidance,
            requiredOrientation: const Wrapped.value(Orientation.portrait),
            isOrientationCorrect: false),
        act: (bloc) => bloc.add(
          VideoCaptureFlowOrientationChanged(orientation: Orientation.portrait),
        ),
        expect: () => [
          isA<VideoCaptureFlowState>().having((s) => s.isOrientationCorrect, 'isOrientationCorrect', true),
        ],
      );
      blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
        'when videoCaptureGuidance stage and requiredOrientation is landscape and orientation set to landscape emits isOrientationCorrect as true',
        build: () => VideoCaptureFlowBloc(),
        seed: () => VideoCaptureFlowState.empty().copyWith(
            stage: VideoCaptureStage.videoCaptureGuidance,
            requiredOrientation: const Wrapped.value(Orientation.landscape),
            isOrientationCorrect: false),
        act: (bloc) => bloc.add(
          VideoCaptureFlowOrientationChanged(orientation: Orientation.landscape),
        ),
        expect: () => [
          isA<VideoCaptureFlowState>().having((s) => s.isOrientationCorrect, 'isOrientationCorrect', true),
        ],
      );
      blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
        'when videoCaptureGuidance stage and requiredOrientation is landscape and orientation set to portrait emits isOrientationCorrect as false',
        build: () => VideoCaptureFlowBloc(),
        seed: () => VideoCaptureFlowState.empty().copyWith(
            stage: VideoCaptureStage.videoCaptureGuidance,
            requiredOrientation: const Wrapped.value(Orientation.landscape),
            isOrientationCorrect: true),
        act: (bloc) => bloc.add(
          VideoCaptureFlowOrientationChanged(orientation: Orientation.portrait),
        ),
        expect: () => [
          isA<VideoCaptureFlowState>().having((s) => s.isOrientationCorrect, 'isOrientationCorrect', false),
        ],
      );

      blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
        'when shotTypeSelection stage and requiredOrientation is portrait and orientation set to landscape emits isOrientationCorrect as false',
        build: () => VideoCaptureFlowBloc(),
        seed: () => VideoCaptureFlowState.empty().copyWith(
            stage: VideoCaptureStage.shotTypeSelection,
            requiredOrientation: const Wrapped.value(Orientation.portrait),
            isOrientationCorrect: true),
        act: (bloc) => bloc.add(
          VideoCaptureFlowOrientationChanged(orientation: Orientation.landscape),
        ),
        expect: () => [
          isA<VideoCaptureFlowState>().having((s) => s.isOrientationCorrect, 'isOrientationCorrect', false),
        ],
      );
      blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
        'when shotTypeSelection stage and requiredOrientation is portrait and orientation set to portrait emits isOrientationCorrect as true',
        build: () => VideoCaptureFlowBloc(),
        seed: () => VideoCaptureFlowState.empty().copyWith(
            stage: VideoCaptureStage.shotTypeSelection,
            requiredOrientation: const Wrapped.value(Orientation.portrait),
            isOrientationCorrect: false),
        act: (bloc) => bloc.add(
          VideoCaptureFlowOrientationChanged(orientation: Orientation.portrait),
        ),
        expect: () => [
          isA<VideoCaptureFlowState>().having((s) => s.isOrientationCorrect, 'isOrientationCorrect', true),
        ],
      );
      blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
        'when shotTypeSelection stage and requiredOrientation is landscape and orientation set to landscape emits isOrientationCorrect as true',
        build: () => VideoCaptureFlowBloc(),
        seed: () => VideoCaptureFlowState.empty().copyWith(
            stage: VideoCaptureStage.shotTypeSelection,
            requiredOrientation: const Wrapped.value(Orientation.landscape),
            isOrientationCorrect: false),
        act: (bloc) => bloc.add(
          VideoCaptureFlowOrientationChanged(orientation: Orientation.landscape),
        ),
        expect: () => [
          isA<VideoCaptureFlowState>().having((s) => s.isOrientationCorrect, 'isOrientationCorrect', true),
        ],
      );
      blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
        'when shotTypeSelection stage and requiredOrientation is landscape and orientation set to portrait emits isOrientationCorrect as false',
        build: () => VideoCaptureFlowBloc(),
        seed: () => VideoCaptureFlowState.empty().copyWith(
            stage: VideoCaptureStage.shotTypeSelection,
            requiredOrientation: const Wrapped.value(Orientation.landscape),
            isOrientationCorrect: true),
        act: (bloc) => bloc.add(
          VideoCaptureFlowOrientationChanged(orientation: Orientation.portrait),
        ),
        expect: () => [
          isA<VideoCaptureFlowState>().having((s) => s.isOrientationCorrect, 'isOrientationCorrect', false),
        ],
      );

      blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
        'when approval stage and requiredOrientation is portrait and orientation set to landscape emits isOrientationCorrect as false',
        build: () => VideoCaptureFlowBloc(),
        seed: () => VideoCaptureFlowState.empty().copyWith(
            stage: VideoCaptureStage.approval,
            requiredOrientation: const Wrapped.value(Orientation.portrait),
            isOrientationCorrect: true),
        act: (bloc) => bloc.add(
          VideoCaptureFlowOrientationChanged(orientation: Orientation.landscape),
        ),
        expect: () => [
          isA<VideoCaptureFlowState>().having((s) => s.isOrientationCorrect, 'isOrientationCorrect', false),
        ],
      );
      blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
        'when approval stage and requiredOrientation is portrait and orientation set to portrait emits isOrientationCorrect as true',
        build: () => VideoCaptureFlowBloc(),
        seed: () => VideoCaptureFlowState.empty().copyWith(
            stage: VideoCaptureStage.approval,
            requiredOrientation: const Wrapped.value(Orientation.portrait),
            isOrientationCorrect: false),
        act: (bloc) => bloc.add(
          VideoCaptureFlowOrientationChanged(orientation: Orientation.portrait),
        ),
        expect: () => [
          isA<VideoCaptureFlowState>().having((s) => s.isOrientationCorrect, 'isOrientationCorrect', true),
        ],
      );
      blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
        'when approval stage and requiredOrientation is landscape and orientation set to landscape emits isOrientationCorrect as true',
        build: () => VideoCaptureFlowBloc(),
        seed: () => VideoCaptureFlowState.empty().copyWith(
            stage: VideoCaptureStage.approval,
            requiredOrientation: const Wrapped.value(Orientation.landscape),
            isOrientationCorrect: false),
        act: (bloc) => bloc.add(
          VideoCaptureFlowOrientationChanged(orientation: Orientation.landscape),
        ),
        expect: () => [
          isA<VideoCaptureFlowState>().having((s) => s.isOrientationCorrect, 'isOrientationCorrect', true),
        ],
      );
      blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
        'when approval stage and requiredOrientation is landscape and orientation set to portrait emits isOrientationCorrect as false',
        build: () => VideoCaptureFlowBloc(),
        seed: () => VideoCaptureFlowState.empty().copyWith(
            stage: VideoCaptureStage.approval,
            requiredOrientation: const Wrapped.value(Orientation.landscape),
            isOrientationCorrect: true),
        act: (bloc) => bloc.add(
          VideoCaptureFlowOrientationChanged(orientation: Orientation.portrait),
        ),
        expect: () => [
          isA<VideoCaptureFlowState>().having((s) => s.isOrientationCorrect, 'isOrientationCorrect', false),
        ],
      );
    });

    group('filming process started tests', () {
      blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
        'when videoCaptureGuidance stage emits stage as shotTypeSelection and previousStage as  shotTypeSelection',
        build: () => VideoCaptureFlowBloc(),
        seed: () => VideoCaptureFlowState.empty().copyWith(
          stage: VideoCaptureStage.videoCaptureGuidance,
        ),
        act: (bloc) => bloc.add(
          VideoCaptureFlowFilmingProcessStarted(),
        ),
        expect: () => [
          isA<VideoCaptureFlowState>()
              .having((s) => s.stage, 'stage', VideoCaptureStage.shotTypeSelection)
              .having((s) => s.previousStage, 'previousStage', VideoCaptureStage.videoCaptureGuidance),
        ],
      );

      blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
        'when approval stage emits stage as shotTypeSelection and previousStage as  approval',
        build: () => VideoCaptureFlowBloc(),
        seed: () => VideoCaptureFlowState.empty().copyWith(
          stage: VideoCaptureStage.approval,
        ),
        act: (bloc) => bloc.add(
          VideoCaptureFlowFilmingProcessStarted(),
        ),
        expect: () => [
          isA<VideoCaptureFlowState>()
              .having((s) => s.stage, 'stage', VideoCaptureStage.shotTypeSelection)
              .having((s) => s.previousStage, 'previousStage', VideoCaptureStage.approval),
        ],
      );
    });

    group('shot style selected tests', () {
      blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
        'emits state with selected shotstyle',
        build: () => VideoCaptureFlowBloc(),
        seed: () => VideoCaptureFlowState.empty().copyWith(
            stage: VideoCaptureStage.shotTypeSelection, selectedShotStyle: const Wrapped.value(ShotStyle.walkthrough)),
        act: (bloc) => bloc.add(
          VideoCaptureFlowShotStyleSelected(shotStyle: ShotStyle.cinematic),
        ),
        expect: () =>
            [isA<VideoCaptureFlowState>().having((s) => s.selectedShotStyle, 'selectedShotStyle', ShotStyle.cinematic)],
      );
    });

    group('filming started tests', () {
      blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
        'emits stage as recording',
        build: () => VideoCaptureFlowBloc(),
        seed: () => VideoCaptureFlowState.empty().copyWith(
          stage: VideoCaptureStage.shotTypeSelection,
        ),
        act: (bloc) => bloc.add(
          VideoCaptureFlowFilmingStarted(),
        ),
        expect: () => [
          isA<VideoCaptureFlowState>()
              .having((s) => s.stage, 'stage', VideoCaptureStage.recording)
              .having((s) => s.previousStage, 'previousStage', VideoCaptureStage.shotTypeSelection),
        ],
      );
    });

    group('filming finished tests', () {
      blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
        'emits state with stage as approval and correct video clip based on generated filepath, scene and orientation',
        build: () => VideoCaptureFlowBloc(),
        seed: () => VideoCaptureFlowState.empty().copyWith(
            stage: VideoCaptureStage.recording,
            currentScene: Wrapped.value(scene1),
            requiredOrientation: const Wrapped.value(Orientation.landscape),
            selectedShotStyle: const Wrapped.value(ShotStyle.walkthrough)),
        act: (bloc) => bloc.add(
          VideoCaptureFlowFilmingFinished('/scene1.mp4'),
        ),
        expect: () => [
          isA<VideoCaptureFlowState>()
              .having((s) => s.stage, 'stage', VideoCaptureStage.approval)
              .having((s) => s.previousStage, 'previousStage', VideoCaptureStage.recording)
              .having(
                  (s) => s.videoClip,
                  'videoClip',
                  VideoClipResult(
                      sceneId: scene1.sceneId,
                      sceneType: scene1.sceneType,
                      filePath: '/scene1.mp4',
                      orientation: ClipOrientation.landscape,
                      shotStyle: ShotStyle.walkthrough)),
        ],
      );
    });

    group('video capture approval tests', () {
      blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
        'emits correct state with stage as completion when all scenes are completed',
        build: () => VideoCaptureFlowBloc(),
        seed: () => VideoCaptureFlowState.empty().copyWith(
          stage: VideoCaptureStage.approval,
          requiredScenes: requiredScenes,
          currentScene: Wrapped.value(scene2),
          completedClips: [scene1landscape, scene1portrait, scene2landscape],
          videoClip: Wrapped.value(scene2portrait),
          requiredOrientation: const Wrapped.value(Orientation.landscape),
        ),
        act: (bloc) => bloc.add(
          VideoCaptureFlowShotApproved(),
        ),
        expect: () => [
          isA<VideoCaptureFlowState>()
              .having((s) => s.stage, 'stage', VideoCaptureStage.completion)
              .having((s) => s.previousStage, 'previousStage', VideoCaptureStage.approval)
              .having((s) => s.videoClip, 'videoClip', null)
              .having((s) => s.currentScene, 'currentScene', null)
              .having((s) => s.requiredOrientation, 'requiredOrientation', null)
              .having((s) => s.selectedShotStyle, 'selectedShotStyle', null)
              .having((s) => s.completedClips.last, 'completedClips', scene2portrait)
        ],
      );

      blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
        'emits correct state with stage as orientationMessaging when all clips in a scene are completed and there are more scenes to capture',
        build: () => VideoCaptureFlowBloc(),
        seed: () => VideoCaptureFlowState.empty().copyWith(
            stage: VideoCaptureStage.approval,
            requiredScenes: requiredScenes,
            currentScene: Wrapped.value(scene1),
            completedClips: [scene1landscape],
            videoClip: Wrapped.value(scene1portrait),
            requiredOrientation: const Wrapped.value(Orientation.portrait),
            selectedShotStyle: const Wrapped.value(ShotStyle.walkthrough)),
        act: (bloc) => bloc.add(
          VideoCaptureFlowShotApproved(),
        ),
        expect: () => [
          isA<VideoCaptureFlowState>()
              .having((s) => s.stage, 'stage', VideoCaptureStage.orientationMessaging)
              .having((s) => s.previousStage, 'previousStage', VideoCaptureStage.approval)
              .having((s) => s.videoClip, 'videoClip', null)
              .having((s) => s.currentScene, 'currentScene', scene2)
              .having((s) => s.requiredOrientation, 'requiredOrientation', Orientation.landscape)
              .having((s) => s.selectedShotStyle, 'selectedShotStyle', null)
              .having((s) => s.completedClips.last, 'completedClips', scene1portrait)
        ],
      );

      blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
        'emits correct state with stage as orientationMessaging when all clips in a scene are not completed',
        build: () => VideoCaptureFlowBloc(),
        seed: () => VideoCaptureFlowState.empty().copyWith(
            stage: VideoCaptureStage.approval,
            requiredScenes: requiredScenes,
            currentScene: Wrapped.value(scene2),
            completedClips: [scene1landscape, scene1portrait],
            videoClip: Wrapped.value(scene2landscape),
            requiredOrientation: const Wrapped.value(Orientation.landscape),
            selectedShotStyle: const Wrapped.value(ShotStyle.walkthrough)),
        act: (bloc) => bloc.add(
          VideoCaptureFlowShotApproved(),
        ),
        expect: () => [
          isA<VideoCaptureFlowState>()
              .having((s) => s.stage, 'stage', VideoCaptureStage.orientationMessaging)
              .having((s) => s.previousStage, 'previousStage', VideoCaptureStage.approval)
              .having((s) => s.videoClip, 'videoClip', null)
              .having((s) => s.currentScene, 'currentScene', scene2)
              .having((s) => s.requiredOrientation, 'requiredOrientation', Orientation.portrait)
              .having((s) => s.selectedShotStyle, 'selectedShotStyle', ShotStyle.walkthrough)
              .having((s) => s.completedClips.last, 'completedClips', scene2landscape)
        ],
      );
    });
  });
}
