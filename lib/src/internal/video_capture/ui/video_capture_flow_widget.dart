import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_capture/src/internal/video_capture/bloc/video_capture_bloc.dart';
import 'package:video_capture/src/internal/video_capture/ui/video_capture_flow_view.dart';
import 'package:video_capture/src/public/model/scene_capture_request.dart';
import 'package:video_capture/src/public/model/video_capture_config.dart';
import 'package:video_capture/src/public/model/video_clip_result.dart';

class VideoCaptureFlowWidget extends StatefulWidget {
  final VideoCaptureConfig config;
  final List<SceneCaptureRequest> selectedSceneTypes;
  final List<VideoClipResult>? completedClips;
  final VideoCaptureFlowBloc? videoCaptureFlowBloc;
  const VideoCaptureFlowWidget(
      {super.key,
      required this.config,
      required this.selectedSceneTypes,
      this.completedClips,
      this.videoCaptureFlowBloc});

  @override
  State<VideoCaptureFlowWidget> createState() => _VideoCaptureFlowWidgetState();
}

class _VideoCaptureFlowWidgetState extends State<VideoCaptureFlowWidget> {
  late final VideoCaptureFlowBloc _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = widget.videoCaptureFlowBloc ?? VideoCaptureFlowBloc();
    _bloc.add(
      VideoCaptureFlowStarted(
        requiredScenes: widget.selectedSceneTypes,
        currentOrientation: MediaQuery.of(context).orientation,
        completedClips: widget.completedClips,
      ),
    );
  }

  @override
  void dispose() {
    if (widget.videoCaptureFlowBloc == null) {
      _bloc.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VideoCaptureFlowBloc>.value(
      value: _bloc,
      child: VideoCaptureFlowView(
        videoCaptureConfig: widget.config,
      ),
    );
  }
}
