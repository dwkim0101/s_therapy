import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sound_therapy/Component/CustomRaisedButton.dart';
import 'package:sound_therapy/Component/CustomSwitch.dart';
import 'package:sound_therapy/Component/CustomValuePicker.dart';

// ignore: must_be_immutable
class TimerPage extends StatefulWidget {
  bool alarmConfig = false;
  int _timerHour = 0;
  int _timerMin = 0;
  static Timer _timer;
  void Function() onTimedOut;
  TimerPage({this.alarmConfig = false, this.onTimedOut});
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        Icon(
          Icons.access_time,
          color: Colors.black54,
          size: 35,
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          "Shut-Out Timer",
          style: TextStyle(color: Colors.black54, fontSize: 22),
        ),
        SizedBox(
          height: 16,
        ),
        Text("Set the timer for S therapy to stop playing",
            style: TextStyle(color: Colors.black54, fontSize: 17)),
        Container(
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                width: 310,
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.black)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CustomValuePicker.integer(
                        initialValue: widget._timerHour,
                        maxValue: 24,
                        minValue: 0,
                        infiniteLoop: true,
                        onChanged: (v) {
                          widget._timerHour = v;
                          setState(() {});
                        },
                      ),
                      Text(
                        "hours",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      CustomValuePicker.integer(
                        initialValue: widget._timerMin,
                        maxValue: 60,
                        minValue: 0,
                        infiniteLoop: true,
                        onChanged: (v) {
                          widget._timerMin = v;
                          setState(() {});
                        },
                      ),
                      Text(
                        "min",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              "Alarm",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            CustomSwitch(
              value: widget.alarmConfig,
              onChanged: (bool value) {
                setState(() {
                  print(value);
                  widget.alarmConfig = value;
                  SharedPreferences.getInstance().then((prefs) {
                    prefs.setBool("alram", value);
                  });
                });
              },
            ),
          ],
        ),
        SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new CustomRaisedButton(
              text: "Cancel",
              bgColor: Color(0xffff5a8c),
              textColor: Colors.white,
              onPressed: () {
                if (TimerPage._timer != null) TimerPage._timer.cancel();
                Navigator.pop(context);
              },
            ),
            new CustomRaisedButton(
              text: "Set Timer",
              bgColor: Colors.white,
              borderColor: Color(0xffff5a8c),
              textColor: Color(0xffff5a8c),
              onPressed: () {
                Navigator.pop(context);
                print("start timer ${widget._timerHour}hour ${widget._timerMin}min");
                TimerPage._timer = Timer.periodic(
                  Duration(hours:widget._timerHour, minutes: widget._timerMin), 
                  //Duration(hours:0, minutes: 0, seconds: 4), 
                  (Timer timer) {
                  timer.cancel();
                  widget.onTimedOut?.call();
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
