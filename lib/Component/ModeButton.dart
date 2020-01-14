import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:sound_therapy/Component/RoundedBackground.dart';

enum ModeChangeEvent { a, h, d, f, r,init }

class ModeChangeBloc extends Bloc<ModeChangeEvent, String> {
  @override
  String get initialState => "INIT";

  @override
  Stream<String> mapEventToState(ModeChangeEvent event) async* {
    switch (event) {
      case ModeChangeEvent.a:
        yield "A";
        break;
      case ModeChangeEvent.h:
        yield "H";
        break;
      case ModeChangeEvent.d:
        yield "D";
        break;
      case ModeChangeEvent.f:
        yield "F";
        break;
      case ModeChangeEvent.r:
        yield "R";
        break;
      case ModeChangeEvent.init:
        yield "INIT";
        break;
      default:
        yield "";
    }
  }
}

// ignore: must_be_immutable
class ModeButton extends StatelessWidget {
  Color color;
  String text;
  ModeButton({this.color = Colors.black, this.text = "Z"});
  static occurModeChagedEvent(BuildContext context, String mode){
    if (mode == "A")
      BlocProvider.of<ModeChangeBloc>(context).dispatch(ModeChangeEvent.a);
    if (mode == "H")  
      BlocProvider.of<ModeChangeBloc>(context).dispatch(ModeChangeEvent.h);
    if (mode == "D")
      BlocProvider.of<ModeChangeBloc>(context).dispatch(ModeChangeEvent.d);
    if (mode == "F")
      BlocProvider.of<ModeChangeBloc>(context).dispatch(ModeChangeEvent.f);
    if (mode == "R")
      BlocProvider.of<ModeChangeBloc>(context).dispatch(ModeChangeEvent.r);
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: BlocProvider.of<ModeChangeBloc>(context),
        listener: (context, state){},
        child: BlocBuilder(
            bloc: BlocProvider.of<ModeChangeBloc>(context),
            builder: (context, state) {
              return InkWell(
                onTap: () => occurModeChagedEvent(context, text),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    if (state == text)
                      SelectedBackground(color:color),
                    if (state != text) 
                      UnselectedBackground(),
                    Text(
                      text,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              );
            }));
  }
}
// ignore: must_be_immutable
class SelectedBackground extends StatelessWidget {
  Color color;
  SelectedBackground({this.color=Colors.black});
  @override
  Widget build(BuildContext context) {
    return RoundedBackground(color: color, size:50,);
  }
}

class UnselectedBackground extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(color: Colors.white, width: 3),
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
    );
  }
}
