import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BackgroundTemplate extends StatefulWidget {
  String bgPath;
  String bgAniPath;
  static Map<String, String> bgPaths;
  static Map<String, Image> bgs;
  static void preloadBg(BuildContext context) async{
    BackgroundTemplate.bgs = Map<String,Image>();
    BackgroundTemplate.bgPaths = Map<String,String>();
    BackgroundTemplate.bgPaths["A"] = "images/bg_adrenaline.png";
    BackgroundTemplate.bgPaths["H"] = "images/bg_healing.png";
    BackgroundTemplate.bgPaths["D"] = "images/bg_deepsleep.png";
    BackgroundTemplate.bgPaths["F"] = "images/bg_focus.png";
    BackgroundTemplate.bgPaths["R"] = "images/bg_recovery.png";
    await precacheImage(AssetImage(BackgroundTemplate.bgPaths["A"]), context);
    await precacheImage(AssetImage(BackgroundTemplate.bgPaths["H"]), context);
    await precacheImage(AssetImage(BackgroundTemplate.bgPaths["D"]), context);
    await precacheImage(AssetImage(BackgroundTemplate.bgPaths["F"]), context);
    await precacheImage(AssetImage(BackgroundTemplate.bgPaths["R"]), context);
    print("preload~~~~");
  }
  BackgroundTemplate({this.bgPath="", this.bgAniPath=""});
  @override
  _BackgroundTemplateState createState() => _BackgroundTemplateState();
}

class _BackgroundTemplateState extends State<BackgroundTemplate> with TickerProviderStateMixin{
  AnimationController _animationController;
  Animation<double> _backgroundAnimation;
  bool isForard = true;
  @override
  void initState() {
    print("init!!!!" + widget.bgAniPath);
    super.initState();
    
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 4));

    _backgroundAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
                _animationController.reverse();
            }
            if (animationStatus == AnimationStatus.dismissed) {
              _animationController.forward();
            }
          });

    _animationController.forward();
  }
  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    print("didChangeDependencies!!!!!!" + widget.bgAniPath);
    // BackgroundTemplate.preloadBg(context);
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return 
      Image.asset(
      BackgroundTemplate.bgPaths[widget.bgPath],
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      alignment: FractionalOffset(_backgroundAnimation.value, 0),
    );

  }
}
