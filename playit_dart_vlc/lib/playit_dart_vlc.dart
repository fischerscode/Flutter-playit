library playit_dart_vlc;

import 'dart:io';
import 'dart:ui';

import 'package:path/path.dart' as pathLib;
import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/widgets.dart';
import 'package:playit_common/playit_common.dart';

class ItPlayerControllerVLC extends ItPlayerController {
  final Player _player;

  ItPlayerControllerVLC(PlayItSource source)
      : _player = Player(id: DateTime.now().millisecond),
        super.internal() {
    if (source is PlayItNetworkSource) {
      _player.add(Media.network(
        source.resource,
        startTime: source.startTime,
        stopTime: source.stopTime,
      ));
    } else if (source is PlayItFileSource) {
      _player.add(Media.file(
        File(source.path),
        startTime: source.startTime,
        stopTime: source.stopTime,
      ));
    }

    _player.currentStream.listen((event) {});
    _player.playbackStream.listen((event) {
      value = value.copyWith(isPlaying: event.isPlaying);
    });
    _player.positionStream.listen((event) {
      value = value.copyWith(
        duration: event.duration,
        position: event.position,
      );
    });
    _player.generalStream.listen((event) {
      value = value.copyWith(playbackSpeed: event.rate);
    });
    _player.videoDimensionsStream.listen((event) {
      value = value.copyWith(
          size: Size(event.width.toDouble(), event.height.toDouble()));
    });
  }

  @override
  Widget buildPlayer() {
    return Video(
      key: ObjectKey(this),
      player: _player,
      showControls: false,
    );
  }

  @override
  Future<void> pause() async {
    _player.pause();
  }

  @override
  Future<void> play() async {
    _player.play();
  }

  static void registerWith() {
    DartVLC.initialize();
    ItPlayerController.constructor = (source) => ItPlayerControllerVLC(source);
  }

  @override
  Future<void> takeSnapshot(String outFile) async {
    final file = File(outFile);
    _player.takeSnapshot(
      file,
      _player.videoDimensions.width,
      _player.videoDimensions.height,
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  void seekTo(Duration position) {
    _player.seek(position);
    value = value.copyWith(position: position);
  }

  @override
  void setPlaybackSpeed(double speed) {
    _player.setRate(speed);
  }
}
