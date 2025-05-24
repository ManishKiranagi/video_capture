import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:video_capture/src/helpers/wrapper.dart';
import 'package:video_capture/src/internal/video_capture/bloc/video_capture_bloc.dart';
import 'package:video_capture/src/internal/video_capture/model/video_capture_stage.dart';
import 'package:video_capture/src/public/model/scene_capture_request.dart';
import 'package:video_capture/src/public/model/scene_type.dart';
import 'package:video_capture/src/public/model/video_clip_result.dart';
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

        // expect(bloc.state.requiredScenes, requiredScenes);
        // expect(bloc.state.completedClips, isEmpty);
        // expect(bloc.state.isOrientationCorrect, true);
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
    // blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
    //   'emits state with selected shot style',
    //   build: () => VideoCaptureFlowBloc(
    //     requiredScenes: requiredScenes,
    //     currentOrientation: Orientation.landscape,
    //   ),
    //   act: (bloc) => bloc.add(
    //     const VideoCaptureFlowShotStyleSelected(ShotStyle.closeUp),
    //   ),
    //   expect: () => [
    //     isA<VideoCaptureFlowState>().having((s) => s.selectedShotStyle, 'shotStyle', ShotStyle.closeUp),
    //   ],
    // );

    // blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
    //   'goes to approval after filming finished',
    //   build: () => VideoCaptureFlowBloc(
    //     requiredScenes: requiredScenes,
    //     currentOrientation: Orientation.landscape,
    //   ),
    //   seed: () => VideoCaptureFlowState.initial(
    //     requiredScenes: requiredScenes,
    //     currentOrientation: Orientation.landscape,
    //   ).copyWith(
    //     stage: VideoCaptureStage.recording,
    //     selectedShotStyle: const Wrapped.value(ShotStyle.fullRoom),
    //   ),
    //   act: (bloc) => bloc.add(
    //     const VideoCaptureFlowFilmingFinished('test/path.mp4'),
    //   ),
    //   expect: () => [
    //     isA<VideoCaptureFlowState>()
    //         .having((s) => s.stage, 'stage', VideoCaptureStage.approval)
    //         .having((s) => s.videoClip?.filePath, 'videoClip.path', 'test/path.mp4'),
    //   ],
    // );

    // blocTest<VideoCaptureFlowBloc, VideoCaptureFlowState>(
    //   'completes flow when all scenes and orientations are captured',
    //   build: () => VideoCaptureFlowBloc(
    //     requiredScenes: [
    //       SceneCaptureRequest(sceneId: 'scene1', sceneType: SceneType.bathroom),
    //     ],
    //     completedClips: [
    //       VideoClipResult(
    //         sceneId: 'scene1',
    //         sceneType: SceneType.bathroom,
    //         filePath: 'a.mp4',
    //         orientation: ClipOrientation.landscape,
    //         shotStyle: ShotStyle.fullRoom,
    //       ),
    //     ],
    //     currentOrientation: Orientation.portrait,
    //   ),
    //   seed: () => VideoCaptureFlowState.initial(
    //     requiredScenes: [
    //       SceneCaptureRequest(sceneId: 'scene1', sceneType: SceneType.bathroom),
    //     ],
    //     completedClips: [
    //       VideoClipResult(
    //         sceneId: 'scene1',
    //         sceneType: SceneType.bathroom,
    //         filePath: 'a.mp4',
    //         orientation: ClipOrientation.landscape,
    //         shotStyle: ShotStyle.fullRoom,
    //       ),
    //     ],
    //     currentOrientation: Orientation.portrait,
    //   ).copyWith(
    //     stage: VideoCaptureStage.approval,
    //     selectedShotStyle: const Wrapped.value(ShotStyle.closeUp),
    //     videoClip: Wrapped.value(VideoClipResult(
    //       sceneId: 'scene1',
    //       sceneType: SceneType.bathroom,
    //       filePath: 'b.mp4',
    //       orientation: ClipOrientation.portrait,
    //       shotStyle: ShotStyle.closeUp,
    //     )),
    //   ),
    //   act: (bloc) => bloc.add(const VideoCaptureFlowShotApproved()),
    //   expect: () => [
    //     isA<VideoCaptureFlowState>().having((s) => s.stage, 'stage', VideoCaptureStage.completion),
    //   ],
    // );
  });
}
