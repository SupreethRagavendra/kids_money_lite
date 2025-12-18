import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final Color color;
  final VoidCallback? onPressed;

  const CustomBackButton({
    super.key, 
    this.color = Colors.white,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(Icons.arrow_back, color: color),
        onPressed: onPressed ?? () => Navigator.pop(context),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    );
  }
}
