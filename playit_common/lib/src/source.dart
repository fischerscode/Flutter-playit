part of playit_platform_interface;

abstract class PlayItSource {
  final Duration startTime;
  final Duration stopTime;

  const PlayItSource._(Duration? startTime, Duration? stopTime)
      : startTime = startTime ?? Duration.zero,
        stopTime = stopTime ?? Duration.zero;

  String get resource;
}

class PlayItFileSource extends PlayItSource {
  final String path;
  PlayItFileSource(
    this.path, {
    Duration? startTime,
    Duration? stopTime,
  }) : super._(startTime, stopTime);

  @override
  String get resource {
    if (!kIsWeb) {
      return "file://$path";
    } else {
      return path;
    }
  }
}

class PlayItNetworkSource extends PlayItSource {
  final String uri;

  PlayItNetworkSource(
    this.uri, {
    Duration? startTime,
    Duration? stopTime,
  }) : super._(startTime, stopTime);

  @override
  String get resource => uri;
}
