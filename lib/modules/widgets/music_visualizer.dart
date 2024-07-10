import 'dart:math';
import 'package:flutter/material.dart';

class MusicVisualizer extends StatefulWidget {
  final bool isPlaying;
  final int barCount;
  final double barWidth;
  final Color activeColor;
  final Color inactiveColor;

  const MusicVisualizer({
    Key? key,
    required this.isPlaying,
    this.barCount = 50,
    this.barWidth = 2,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.black
  }) : super(key: key);

  @override
  _MusicVisualizerState createState() => _MusicVisualizerState();
}

class _MusicVisualizerState extends State<MusicVisualizer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<double> _heights;

  @override
  void initState() {
    super.initState();
    // Initialize heights based on bar count
    _heights = List.filled(widget.barCount, 10.0);
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    )..addListener(() {
      setState(() {
        // Randomize heights each time the controller ticks
        _heights = List.generate(widget.barCount, (index) => Random().nextDouble() * 80);
      });
    });
  }

  @override
  void didUpdateWidget(MusicVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying) {
      _controller.repeat(); // Start the animation
    } else {
      _controller.stop(); // Stop the animation
      setState(() {
        // Reset the heights when the animation stops
        _heights = List.filled(widget.barCount, 10.0);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define the total width of the visualizer
    final double visualizerWidth = widget.barWidth * widget.barCount;

    return Container(
      width: visualizerWidth, // Use the total width calculated
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(widget.barCount, (index) {
            return AnimatedContainer(
              duration: Duration(milliseconds: widget.isPlaying ? 100 : 0),
              width: widget.barWidth,
              height: _heights[index],
              color: widget.isPlaying ? widget.activeColor : widget.inactiveColor,
              margin: const EdgeInsets.symmetric(horizontal: 1),
            );
          }),
        ),
      ),
    );
  }

}
