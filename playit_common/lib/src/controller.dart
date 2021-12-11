part of playit_platform_interface;

abstract class ItPlayerController extends ValueNotifier<ItPlayerValue> {
  ItPlayerController.internal([ItPlayerValue? value])
      : super(value ?? ItPlayerValue(duration: Duration.zero));

  static ItPlayerController Function(PlayItSource source) constructor = _create;

  /// Play the video
  Future<void> play();

  /// Pause the video
  Future<void> pause();

  /// Build the player widget
  Widget buildPlayer();

  /// Take a snapshot at the current position and save it in [outFile].
  Future<void> takeSnapshot(String outFile);

  factory ItPlayerController(PlayItSource source) {
    return constructor(source);
  }

  static ItPlayerController _create(dynamic sources) {
    throw Exception("Stup!");
  }
}
