part of playit;

class ItPlayer extends StatelessWidget {
  const ItPlayer(this.controller, {Key? key}) : super(key: key);

  final ItPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return controller.buildPlayer();
  }
}
