part of playit;

class SimpleAnimatedIcon extends StatefulWidget {
  const SimpleAnimatedIcon({
    Key? key,
    required this.showFirst,
    required this.icon,
    Duration? duration,
    this.color,
    this.size,
  })  : duration = duration ?? const Duration(milliseconds: 300),
        super(key: key);

  final bool showFirst;
  final AnimatedIconData icon;
  final Duration duration;
  final Color? color;
  final double? size;

  @override
  _SimpleAnimatedIconState createState() => _SimpleAnimatedIconState();
}

class _SimpleAnimatedIconState extends State<SimpleAnimatedIcon>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  bool? _showFirst;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: widget.showFirst ? 0 : 1,
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SimpleAnimatedIcon oldWidget) {
    if (oldWidget.duration != widget.duration) {
      _controller.dispose();
      _controller = AnimationController(
        vsync: this,
        duration: widget.duration,
        value: _controller.value,
      );
    }
    if (oldWidget.showFirst != widget.showFirst) {
      if (widget.showFirst) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedIcon(
      icon: widget.icon,
      progress: _controller,
      color: widget.color,
      size: widget.size,
    );
  }
}
