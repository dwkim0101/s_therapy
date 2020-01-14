import 'package:flutter/material.dart';
import 'package:sound_therapy/Component/RoundedBackground.dart';
import 'package:sound_therapy/View/MusicControlPage.dart';

// ignore: must_be_immutable
class UtilButton extends StatelessWidget {
  UtilButtonType type;
  void Function(BuildContext context, UtilButtonType type) onClick;
  UtilButton({
    this.type = UtilButtonType.more,
    this.onClick
  });
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
      RoundedBackground(size:40,color: Colors.white,),
      IconButton(
        icon:Icon(getIcon()),
        onPressed: ()=> onClick?.call(context, type),
        iconSize: 25,
        splashColor: Colors.black,
      )
    ],);
  }
  IconData getIcon(){
    switch(this.type){
      case UtilButtonType.pause:
        return Icons.pause;
      case UtilButtonType.resume:
        return Icons.music_note;
      case UtilButtonType.timer:
        return Icons.access_time;
      case UtilButtonType.more:
        return Icons.more_horiz;
      case UtilButtonType.init:
        return Icons.ac_unit;
//      defalut:
//        return Icons.ac_unit;
    }
    return Icons.ac_unit;
  }
}
