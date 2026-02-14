import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RoundedActionButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final bool isLeading;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;

  const RoundedActionButton({
    super.key,
    required this.text,
    required this.iconPath,
    this.isLeading = true,
    required this.onPressed,
    this.backgroundColor = const Color(0xFFF3E5F5),
    this.foregroundColor = const Color(0xFF4A148C),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Ink(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                if (isLeading)
                  SvgPicture.asset(
                    iconPath,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      foregroundColor,
                      BlendMode.srcIn,
                    ),
                  ),
                Text(
                  text,
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (!isLeading)
                  SvgPicture.asset(
                    iconPath,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      foregroundColor,
                      BlendMode.srcIn,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
