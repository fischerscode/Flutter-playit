library playit_video_player;

import 'dart:async';
import 'dart:io';

import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:flutter/widgets.dart';
import 'package:playit_common/playit_common.dart';
import 'package:video_player/video_player.dart';

class ItPlayerControllerVideoPlayer extends ItPlayerController {
  late VideoPlayerController _controller;
  final PlayItSource source;

  ItPlayerControllerVideoPlayer(this.source) : super.internal() {
    final source = this.source;
    if (source is PlayItFileSource) {
      _controller = VideoPlayerController.file(File(source.path))..initialize();
    } else if (source is PlayItNetworkSource) {
      _controller = VideoPlayerController.network(source.uri)..initialize();
    } else {
      throw UnimplementedError(
          "Unsupported source type ${source.runtimeType}!");
    }
    _controller.addListener(() {
      final controllerValue = _controller.value;
      value = ItPlayerValue(
        duration: controllerValue.duration,
        errorDescription: controllerValue.errorDescription,
        isBuffering: controllerValue.isBuffering,
        isInitialized: controllerValue.isInitialized,
        isLooping: controllerValue.isLooping,
        isPlaying: controllerValue.isPlaying,
        playbackSpeed: controllerValue.playbackSpeed,
        position: controllerValue.position,
        size: controllerValue.size,
        volume: controllerValue.volume,
      );
    });
    _controller.seekTo(source.startTime);
  }

  @override
  Widget buildPlayer() {
    return VideoPlayer(_controller);
  }

  @override
  Future<void> pause() async {
    _controller.pause();
  }

  @override
  Future<void> play() async {
    _controller.play();
  }

  @override
  Future<void> takeSnapshot(String outFile) async {
    final source = this.source;
    final completer = Completer<void>();
    FFmpegKit.executeAsync(
        "-ss ${_durationToFFmpeg((await _controller.position) ?? Duration.zero)} -i ${source is PlayItFileSource ? source.path : null} -frames:v 1 $outFile",
        (session) async {
      final code = await session.getReturnCode();
      if (code?.isValueSuccess() ?? false) {
        completer.complete();
      } else {
        completer.completeError(Exception(
            (await session.getOutput()) ?? "Failed to create a snapshot."));
      }
    });
    return completer.future;
  }

  static String _durationToFFmpeg(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = (duration.inMilliseconds / 1000) % 60;
    return '$hours:$minutes:$seconds';
  }

  static void registerWith() {
    ItPlayerController.constructor =
        (source) => ItPlayerControllerVideoPlayer(source);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void seekTo(Duration position) {
    _controller.seekTo(position);
  }

  @override
  void setPlaybackSpeed(double speed) {
    _controller.setPlaybackSpeed(speed);
  }
}
