import 'package:flutter/material.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  final double? width;
  final double? height;

  final double? strokeWidth;
  final Color? color;

  const CustomCircularProgressIndicator({
    super.key,
    this.width = 20,
    this.height = 20,
    this.strokeWidth = 2,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth!,
        color: color,
      ),
    );
  }
}
