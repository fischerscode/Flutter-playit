part of playit;

class ItPlayer extends StatelessWidget {
  const ItPlayer(this.controller, {Key? key}) : super(key: key);

  final ItPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        controller.buildPlayer(),
        IconButton(
          color: Colors.white,
          onPressed: () {
            if (controller.value.isPlaying) {
              controller.pause();
            } else {
              controller.play();
            }
          },
          icon:
              Icon(controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
        ),
      ],
    );
  }
}
