import 'package:flutter/material.dart';

class HorizontalProgressLine extends StatelessWidget {
  final int totalSteps;
  final int completedSteps;
  final Color activeColor;
  final Color inactiveColor;

  const HorizontalProgressLine({
    super.key,
    required this.totalSteps,
    required this.completedSteps,
    this.activeColor = Colors.purple,
    this.inactiveColor = const Color(0xFFE0E0E0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      width: double.infinity,
      decoration: BoxDecoration(
        color: inactiveColor,
        borderRadius: BorderRadius.circular(3),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: totalSteps == 0 ? 0 : completedSteps / totalSteps,
        child: Container(
          decoration: BoxDecoration(
            color: activeColor,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}
