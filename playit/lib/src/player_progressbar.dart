part of playit;

class PlayerProgressBar extends StatelessWidget {
  const PlayerProgressBar({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ItPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ItPlayerValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        return ProgressBar(
          progress: value.position,
          total: value.duration,
          onSeek: (position) {
            controller.seekTo(position);
          },
        );
      },
    );
  }
}
