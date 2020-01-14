import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sound_therapy/Component/ModeButton.dart';
import 'package:sound_therapy/Component/UtilButton.dart';
import 'package:sound_therapy/Module/STFitnessGetter.dart';
import 'package:sound_therapy/Module/STMediaChooser.dart';

//import 'package:sound_therapy/View/Background/Adrenaline.dart';
import 'package:sound_therapy/View/Background/BackgroundTemplate.dart';
//import 'package:sound_therapy/View/Background/Healling.dart';
import 'package:sound_therapy/View/SubView/BaseBottomSheet.dart';
import 'package:sound_therapy/View/SubView/SettingPage.dart';
import 'package:sound_therapy/View/SubView/TimerPage.dart';
import 'package:weather/weather.dart';



enum UtilButtonEvent { pause, resume, timer, more, init }
enum UtilButtonType { pause, resume, timer, more, init }
class UtilButtonBloc extends Bloc<UtilButtonEvent, UtilButtonEvent> {
  @override
  UtilButtonEvent get initialState => UtilButtonEvent.init;

  @override
  Stream<UtilButtonEvent> mapEventToState(UtilButtonEvent event) async* {
    switch (event) {
      case UtilButtonEvent.pause:
        yield UtilButtonEvent.pause;
        break;
      case UtilButtonEvent.resume:
        yield UtilButtonEvent.resume;
        break;
      case UtilButtonEvent.timer:
        yield UtilButtonEvent.timer;
        break;
      case UtilButtonEvent.more:
        yield UtilButtonEvent.more;
        break;
      case UtilButtonEvent.init:
        yield UtilButtonEvent.init;
        break;
    }
  }
}

class MusicControlPage extends StatefulWidget {
  static bool isFirst = true;
  @override
  _MusicControlPageState createState() => _MusicControlPageState();
}

class _MusicControlPageState extends State<MusicControlPage> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  String modeChangeState = "A";
  final List<String> modeList = ["A", "H", "D", "F", "R",];
  
  Widget background;
  AudioPlayer audioPlayer;
  StreamSubscription _playerCompleteSubscription;
  @override
  void initState() {
    print("initState");
    super.initState();
    _refreshBackground();
    audioPlayer = AudioPlayer();
    _playerCompleteSubscription =
    audioPlayer.onPlayerCompletion.listen((event) {
      print("onPlayerCompletion");
      _play();
    });
    // AudioPlayer.logEnabled = true;
    if (MusicControlPage.isFirst == false) BlocProvider.of<ModeChangeBloc>(context).dispatch(ModeChangeEvent.a);
  }

  @override
  void dispose() {
    audioPlayer.stop();
    _playerCompleteSubscription?.cancel();
    super.dispose();
  }

  void gotoNextMode() {
    for (int i = 0 ;i < modeList.length; i++){
      if (modeList[i] == modeChangeState) {
          modeChangeState = i == modeList.length-1 ? modeList[0] : modeList[i+1];
          break;
      }
    }
    ModeButton.occurModeChagedEvent(context, modeChangeState);
  }

  void gotoPreviousMode() {
    for (int i = 0 ;i < modeList.length; i++) {
      if (modeList[i] == modeChangeState){
        modeChangeState = i == 0 ? modeList[modeList.length-1] : modeList[i-1];
        break;
      }
    }
    ModeButton.occurModeChagedEvent(context, modeChangeState);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<ModeChangeEvent, String>(
              bloc: BlocProvider.of<ModeChangeBloc>(context),
              listener: (BuildContext context, String state) {
                BlocProvider.of<UtilButtonBloc>(context).dispatch(UtilButtonEvent.init);
                print("Mode Changed $state");
                modeChangeState = state;
                _play();
                _refreshBackground();
                setState(() {});
              }),
          BlocListener<UtilButtonEvent, UtilButtonEvent>(
            bloc: BlocProvider.of<UtilButtonBloc>(context),
            listener: processUtilButtonEvent,
          ),
        ],
        child: Scaffold(
            key: _scaffoldKey,
            body: Stack(fit: StackFit.loose, children: <Widget>[
              background,
              Align(
                alignment: FractionalOffset(0.5, 0.1),
                child: Text(
                  getTitle(modeChangeState),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
              Align(
                alignment: FractionalOffset(0.5, 0.8),
                child: ModeButtonSet(),
              ),
              Align(
                  alignment: FractionalOffset(0.5, 0.9),
                  child: UtilButtonSet()),
            ])));
  }

  void _refreshBackground() {
    background = BackgroundTemplate(bgAniPath: "", bgPath: modeChangeState,);
  }

  String getTitle(state) {
    String title = "UNKNOWN";
    if (state == "A") title = "Adrenaline Mode";
    if (state == "D") title = "Deep-Sleep Mode";
    if (state == "H") title = "Healing Mode";
    if (state == "F") title = "Focus Mode";
    if (state == "R") title = "Recovery Mode";
    return title;
  }

  void processUtilButtonEvent(context, state) {
    if (state == UtilButtonEvent.timer) _showBottomSheet(context);
    if (state == UtilButtonEvent.more) _showSettingPage(context);
    if (state == UtilButtonEvent.resume) _resume();
    if (state == UtilButtonEvent.pause) _pause();
  }

  void _pause() {
    print("pause music");
    audioPlayer.pause();
  }
  void _resume() {
    print("resume music");
    audioPlayer.resume();
  }
  void _play() {
    print("play music11");
    STMediaChooser musicChooser = STMediaChooser();
    audioPlayer.release().then((onValue){
      musicChooser.recommandMediaUrl(modeChangeState).then((url) => audioPlayer.play(url));
    });
  }

  void _showSettingPage(context) {
    STFitnessGetter test = STFitnessGetter();
    test.hasPermission().then((value) {
      print("fit permission : $value");
    });
    SharedPreferences.getInstance().then((prefs) {
      _scaffoldKey.currentState
          .showBottomSheet((context) {
            return BaseButtomSheet(
              backgroundColor: Colors.white,
              contents: SettingPage(),
            );
          })
          .closed
          .whenComplete(() {
            if (mounted) {}
            BlocProvider.of<UtilButtonBloc>(context)
                .dispatch(UtilButtonEvent.init);
          });
    });
  }

  void _showBottomSheet(context) {
    SharedPreferences.getInstance().then((prefs) {
      _scaffoldKey.currentState
          .showBottomSheet((bottomSheetContext) {
            return BaseButtomSheet(
              backgroundColor: Colors.white.withAlpha(220),
              contents: TimerPage(
                alarmConfig: prefs.getBool("alram") ?? false,
                onTimedOut: (){
                  BlocProvider.of<UtilButtonBloc>(context).dispatch(UtilButtonEvent.pause);
                },
              ),
            );
          })
          .closed
          .whenComplete(() {
            if (mounted) {}
            BlocProvider.of<UtilButtonBloc>(context)
                .dispatch(UtilButtonEvent.init);
          });
    });
  }
}

class UtilButtonSet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        UtilButton(type: UtilButtonType.pause, onClick: occurClickEvent,),
        SizedBox(width: 10),
        UtilButton(type: UtilButtonType.resume, onClick: occurClickEvent,),
        SizedBox(width: 10),
        UtilButton(type: UtilButtonType.timer, onClick: occurClickEvent,),
        SizedBox(width: 10),
        UtilButton(type: UtilButtonType.more, onClick: occurClickEvent,),
      ],
    );
  }
  void occurClickEvent(context, type) {
    if (type == UtilButtonType.timer) BlocProvider.of<UtilButtonBloc>(context).dispatch(UtilButtonEvent.timer);
    if (type == UtilButtonType.more) BlocProvider.of<UtilButtonBloc>(context).dispatch(UtilButtonEvent.more);
    if (type == UtilButtonType.resume) BlocProvider.of<UtilButtonBloc>(context).dispatch(UtilButtonEvent.resume);
    if (type == UtilButtonType.pause) BlocProvider.of<UtilButtonBloc>(context).dispatch(UtilButtonEvent.pause);
  }
}

class ModeButtonSet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ModeButton(
          color: Color(0xFFFA6A80),
          text: 'A',
        ),
        SizedBox(
          width: 10,
        ),
        ModeButton(
          color: Color(0xff6ed0b8),
          text: 'H',
        ),
        SizedBox(
          width: 10,
        ),
        ModeButton(
          color: Color(0xff96a3ff),
          text: 'D',
        ),
        SizedBox(
          width: 10,
        ),
        ModeButton(
          color: Color(0xFFb29ce2),
          text: 'F',
        ),
        SizedBox(
          width: 10,
        ),
        ModeButton(
          color: Color(0xFFfc9a2f),
          text: 'R',
        ),
      ],
    );
  }
}
