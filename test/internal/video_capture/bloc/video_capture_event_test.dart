import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:video_capture/src/internal/video_capture/bloc/video_capture_bloc.dart';
import 'package:video_capture/src/public/model/shot_style.dart';

void main() {
  group('VideoCaptureFlowOrientationChanged', () {
    test('props contains orientation', () {
      final event = VideoCaptureFlowOrientationChanged(orientation: Orientation.landscape);
      expect(event.props, [Orientation.landscape]);
    });
  });

  group('VideoCaptureFlowFilmingProcessStarted', () {
    test('props is empty list', () {
      final event = VideoCaptureFlowFilmingProcessStarted();
      expect(event.props, []);
    });
  });

  group('VideoCaptureFlowShotStyleSelected', () {
    test('props contains shotStyle', () {
      final event = VideoCaptureFlowShotStyleSelected(shotStyle: ShotStyle.walkthrough);
      expect(event.props, [ShotStyle.walkthrough]);
    });
  });

  group('VideoCaptureFlowFilmingStarted', () {
    test('props is empty list', () {
      final event = VideoCaptureFlowFilmingStarted();
      expect(event.props, []);
    });
  });

  group('VideoCaptureFlowFilmingFinished', () {
    test('props contains videoFilePath', () {
      const path = '/tmp/video.mp4';
      final event = VideoCaptureFlowFilmingFinished(path);
      expect(event.props, [path]);
    });
  });

  group('VideoCaptureFlowShotApproved', () {
    test('props contains videoFilePath', () {
      const path = '/tmp/approved.mp4';
      final event = VideoCaptureFlowShotApproved(videoFilePath: path);
      expect(event.props, [path]);
    });
  });
}
