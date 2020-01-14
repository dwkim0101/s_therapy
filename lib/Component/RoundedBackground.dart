
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RoundedBackground extends StatelessWidget {
  Color color;
  double size;
  RoundedBackground({this.color=Colors.white, this.size=50});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(500),
        color: color,
      ),
    );
  }
}
