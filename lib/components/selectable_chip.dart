import 'package:flutter/material.dart';

class SelectableChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isCircular;
  final Color backgroundColor;
  final Color selectedColor;
  final Color? selectedBackgroundColor;
  final Color baseTextColor;

  const SelectableChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isCircular = true,
    this.backgroundColor = Colors.white,
    this.selectedColor = const Color(0xFFF57C00),
    this.selectedBackgroundColor,
    this.baseTextColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Ink(
          decoration: BoxDecoration(
            color: isSelected
                ? (selectedBackgroundColor ?? Colors.transparent)
                : backgroundColor,
            borderRadius: BorderRadius.circular(30),
            border: isSelected
                ? Border.all(color: selectedColor, width: 1.5)
                : null,
          ),
          child: Container(
            width: isCircular ? 50 : null,
            height: 50,
            padding: isCircular
                ? null
                : const EdgeInsets.symmetric(horizontal: 24),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? selectedColor : baseTextColor,
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
