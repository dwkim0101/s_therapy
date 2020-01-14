import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Color borderColor;
  final Color textColor;
  final VoidCallback onPressed;
  final double elevation;
  final double width;
  final double height;
  const CustomRaisedButton({
    this.text = "",
    this.bgColor = Colors.white,
    this.borderColor = Colors.transparent,
    this.textColor = Colors.black,
    this.elevation = 10,
    this.height = 50,
    this.width = 130,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: bgColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(color: borderColor, width: 3)),
      onPressed: onPressed,
      elevation: elevation,
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        child: Text(text, style: TextStyle(color: textColor, fontSize: 20)),
      ),
    );
  }
}