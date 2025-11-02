import 'package:flutter/material.dart';

class GoogleLogo extends StatelessWidget {
  final double size;
  
  const GoogleLogo({super.key, this.size = 24});

  @override
  Widget build(BuildContext context) {
    // Use local Google logo implementation instead of network image
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size / 8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: Text(
          'G',
          style: TextStyle(
            color: const Color(0xFF4285F4),
            fontSize: size * 0.6,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
      ),
    );
  }
}