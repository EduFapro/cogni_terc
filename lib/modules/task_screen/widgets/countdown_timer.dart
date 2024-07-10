import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CountdownTimer extends StatefulWidget {
  final RxBool countdownTrigger;
  final int initialDurationInSeconds;
  final VoidCallback? onTimerComplete;

  const CountdownTimer({
    Key? key,
    required this.countdownTrigger,
    required this.initialDurationInSeconds,
    this.onTimerComplete,
  }) : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late int remainingTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    remainingTime = widget.initialDurationInSeconds;

    // Listen to the countdownTrigger observable
    widget.countdownTrigger.listen((start) {
      if (start) {
        startTimer();
      } else {
        resetTimer();
      }
    });
  }

  void startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    setState(() {
      remainingTime = widget.initialDurationInSeconds;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        _timer?.cancel();
        if (widget.onTimerComplete != null) {
          widget.onTimerComplete!();
        }
      }
    });
  }

  void resetTimer() {
    _timer?.cancel();
    setState(() {
      remainingTime = widget.initialDurationInSeconds;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$remainingTime',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }


}