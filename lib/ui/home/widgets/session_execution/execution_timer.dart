import 'package:flutter/material.dart';

class ExecutionTimer extends StatelessWidget {
  final int remainingSeconds;

  const ExecutionTimer({super.key, required this.remainingSeconds});

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatTime(remainingSeconds),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 80,
        fontWeight: FontWeight.w900,
        fontFeatures: [FontFeature.tabularFigures()],
      ),
    );
  }

  String _formatTime(int totalSeconds) {
    if (totalSeconds < 60) return "$totalSeconds";
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return "$m:${s.toString().padLeft(2, '0')}";
  }
}
