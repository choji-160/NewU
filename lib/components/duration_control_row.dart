import 'package:flutter/material.dart';

class DurationControlRow extends StatelessWidget {
  final String label;
  final int value;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final Color textColor;

  const DurationControlRow({
    super.key,
    required this.label,
    required this.value,
    required this.onDecrease,
    required this.onIncrease,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: !isDarkMode ? Colors.black.withOpacity(0.03) : Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            _buildButton(Icons.remove, onDecrease),
            SizedBox(
              width: 40,
              child: Text(
                "${value}s",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildButton(Icons.add, onIncrease),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, size: 18, color: textColor),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
