part of playit;

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({
    Key? key,
    required this.controller,
    this.color,
    this.size,
  }) : super(key: key);

  final ItPlayerController controller;
  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ItPlayerValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        return IconButton(
          onPressed: () {
            if (value.isPlaying) {
              controller.pause();
            } else {
              controller.play();
            }
          },
          iconSize: size ?? 24.0,
          icon: SimpleAnimatedIcon(
            showFirst: !value.isPlaying,
            icon: AnimatedIcons.play_pause,
            color: color,
          ),
        );
      },
    );
  }
}
