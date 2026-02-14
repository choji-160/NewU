import 'package:flutter/material.dart';

class CycleProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final double height;
  final double width;
  final Color backgroundColor;
  final Color gradientStartColor;
  final Color gradientEndColor;

  const CycleProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.height = 12.0,
    this.width = double.infinity,
    this.backgroundColor = const Color(0xFFF3E5F5),
    this.gradientStartColor = const Color(0xFFF57C00),
    this.gradientEndColor = const Color(0xFF630068),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final double progressWidth =
                  constraints.maxWidth * (currentStep / totalSteps);
              return Container(
                width: progressWidth,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(height / 2),
                  gradient: LinearGradient(
                    colors: [gradientStartColor, gradientEndColor],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
