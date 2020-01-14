import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:sound_therapy/Component/CustomRaisedButton.dart';
//import 'package:sound_therapy/Component/CustomSwitch.dart';
//import 'package:sound_therapy/Component/CustomValuePicker.dart';

// ignore: must_be_immutable
class BaseButtomSheet extends StatefulWidget {

  Color backgroundColor;
  Widget contents;
  BaseButtomSheet({
    this.backgroundColor = Colors.white,
    this.contents,
  });
  @override
  _BaseButtomSheetState createState() => _BaseButtomSheetState();
}

class _BaseButtomSheetState extends State<BaseButtomSheet> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.bottomCenter,
      height: MediaQuery.of(context).size.height*0.92,
      decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(42), topRight: Radius.circular(42)),
        ),
      child: widget.contents,
    );
  }
}