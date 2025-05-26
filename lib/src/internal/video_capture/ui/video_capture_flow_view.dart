import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_capture/src/internal/video_capture/bloc/video_capture_bloc.dart';
import 'package:video_capture/src/internal/video_capture/helpers/video_capture_flow_state_extensions.dart';
import 'package:video_capture/src/internal/video_capture/model/video_capture_stage.dart';
import 'package:video_capture/src/internal/video_capture/ui/screens/approval_screen.dart';
import 'package:video_capture/src/internal/video_capture/ui/screens/capture_guidance_screen.dart';
import 'package:video_capture/src/internal/video_capture/ui/screens/error_screen.dart';
import 'package:video_capture/src/internal/video_capture/ui/screens/orientation_screen.dart';
import 'package:video_capture/src/internal/video_capture/ui/screens/recording_screen.dart';
import 'package:video_capture/src/internal/video_capture/ui/screens/shot_type_selection_screen.dart';
import 'package:video_capture/src/public/model/video_capture_config.dart';

class VideoCaptureFlowView extends StatelessWidget {
  final VideoCaptureConfig videoCaptureConfig;
  const VideoCaptureFlowView({super.key, required this.videoCaptureConfig});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VideoCaptureFlowBloc, VideoCaptureFlowState>(
      listener: (context, state) {
        final onClipComplete = videoCaptureConfig.onClipComplete;

        if (state.hasReturnedFromApproval && state.lastApprovedClip != null) {
          onClipComplete?.call(state.lastApprovedClip!);
        }

        if (state.hasCompletedFinalClip && state.lastApprovedClip != null) {
          onClipComplete?.call(state.lastApprovedClip!).then((_) {
            videoCaptureConfig.onFlowComplete?.call();
          });
        }
      },
      builder: (context, state) {
        if (!state.isOrientationCorrect) {
          return const OrientationScreen();
        }
        switch (state.stage) {
          case VideoCaptureStage.orientationMessaging:
            return const OrientationScreen();
          case VideoCaptureStage.videoCaptureGuidance:
            return const CaptureGuidanceScreen();
          case VideoCaptureStage.shotTypeSelection:
            return const ShotTypeSelectionScreen();
          case VideoCaptureStage.recording:
            return const RecordingScreen();
          case VideoCaptureStage.approval:
          case VideoCaptureStage.completion:
            return const ApprovalScreen();
          case VideoCaptureStage.error:
            return const ErrorScreen();
          case VideoCaptureStage.uninitialized:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
