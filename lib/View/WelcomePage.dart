import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_therapy/Component/ModeButton.dart';
import 'package:sound_therapy/Module/STFitnessGetter.dart';
import 'package:sound_therapy/Module/STWeatherGetter.dart';

enum WelcomePageEvent { init, next, healthAccess, locationAccess }

class WelcomePageBloc extends Bloc<WelcomePageEvent, String> {
  @override
  String get initialState => "";

  @override
  Stream<String> mapEventToState(WelcomePageEvent event) async* {
    switch (event) {
      case WelcomePageEvent.next:
        yield "next";
        break;
      case WelcomePageEvent.healthAccess:
        yield "healthAccess";
        break;
      case WelcomePageEvent.locationAccess:
        yield "locationAccess";
        break;
      default:
        yield "init";
    }
  }
}

class DotsIndicator extends AnimatedWidget {
  DotsIndicator(
      {this.controller,
      this.itemCount,
      this.onPageSelected,
      this.color: const Color(0xff9b9b9b)})
      : super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color color;

  // The base size of the dots
  static const double _kDotSize = 10.0;

  // The increase in the size of the selected dot
  static const double _kMaxZoom = 1.0;

  // The distance between the center of each dot
  static const double _kDotSpacing = 20.0;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    double dotOpacity = selectedness;
    if (dotOpacity < 0.5) dotOpacity = 0.5;
    return Container(
      width: _kDotSpacing,
      child: Center(
        child: Material(
          color: color.withOpacity(dotOpacity),
          type: MaterialType.circle,
          child: Container(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: InkWell(),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(itemCount, _buildDot),
    );
  }
}

class WelcomeView extends StatefulWidget {
  @override
  State createState() => WelcomeViewState();
}

class WelcomeViewState extends State<WelcomeView> {
  final _controller = PageController();

  static const _kDuration = const Duration(milliseconds: 300);

  static const _kCurve = Curves.ease;

  final _kArrowColor = Colors.black.withOpacity(0.8);
  final _stFitGetter = STFitnessGetter();
  final _stWeatherGetter = STWeatherGetter();
  List<Widget> _pages;

  @override
  void deactivate() {
    print("close Welcome Page");
    BlocProvider.of<ModeChangeBloc>(context).dispatch(ModeChangeEvent.a);
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("isFirst", false);
    });
    super.deactivate();
  }
  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      WelcomeIntro(),
      WelcomeExplain(
        baseColor: Color(0xFFFA6A80),
        // topBtnText: "SKIP",
        // bottomBtnText: "Allow Location Access",
        bottomBtnText: "Continue",
        iconPath: "images/Image 4@3x.png",
        explain:                                 
            "Adrenaline Rush is decreasing the body's ability\nto feel pain and Increasing strength temporarily",
        explainTitle: "Adrenaline Mode",
      ),
      WelcomeExplain(
        baseColor: Color(0xFF8BC9BB),
        bottomBtnText: "Continue",
        iconPath: "images/Image 5@3x.png",
        explain:
            "Healing sound to help you regain\nyour psychological stability",
        explainTitle: "Healing Mode",
      ),
      WelcomeExplain(
        baseColor: Color(0xFFb29ce2),
        // topBtnText: "SKIP",
        // bottomBtnText: "Allow Health Access",
        bottomBtnText: "Continue",
        iconPath: "images/Image 6@3x.png",
        explain: "A sound that induces deep sleep\nthrough white noise.",
        explainTitle: "Deep-Sleep Mode",
      ),
      WelcomeExplain(
        baseColor: Color(0xFF8ca8ec),
        bottomBtnText: "Continue",
        iconPath: "images/Image 7@3x.png",
        explain: "Focus sound that improves\nconcentration and memory",
        explainTitle: "Focus Mode",
      ),
      WelcomeExplain(
        baseColor: Color(0xFFfc9a2f),
        bottomBtnText: "Continue",
        iconPath: "images/Image 8@3x.png",
        explain: "The sound of life’s rejuvenation over depression.",
        explainTitle: "Recovery Mode",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: BlocProvider.of<WelcomePageBloc>(context),
        listener: eventListener,
        child: BlocBuilder(
            bloc: BlocProvider.of<WelcomePageBloc>(context),
            builder: (context, state) {
              return Scaffold(
                body: IconTheme(
                  data: IconThemeData(color: _kArrowColor),
                  child: Stack(
                    children: <Widget>[
                      PageView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: _controller,
                        itemBuilder: (BuildContext context, int index) {
                          return _pages[index];
                        },
                        itemCount: _pages.length,
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: DotsIndicator(
                              controller: _controller,
                              itemCount: _pages.length,
                              onPageSelected: (int page) {
                                _controller.animateToPage(
                                  page,
                                  duration: _kDuration,
                                  curve: _kCurve,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }));
  }

  void requestHealthPermission() {
    _stFitGetter.requestPermission().then((b) {
      // if (b) nextPage();
    });
    //_stFitGetter.read();
  }

  void requestLocationPermission() {
    _stWeatherGetter.requestPermission().then((b) {
      // if (b) nextPage();
    });
  }

  void nextPage() {
    if (_controller.page == _pages.length - 1) {
      Navigator.pop(context);
      return;
    }
    _controller.nextPage(
      duration: _kDuration,
      curve: _kCurve,
    );
  }

  void eventListener(context, state) {
    print(state);
    if (state == "next") nextPage();
    if (state == "healthAccess") requestHealthPermission();
    if (state == "locationAccess") requestLocationPermission();
    BlocProvider.of<WelcomePageBloc>(context).dispatch(WelcomePageEvent.init);
  }
}

// ignore: must_be_immutable
class WelcomeTemplate extends StatelessWidget {
  String backgroundPath;
  String bottomBtnText;
  String midBtnText;
  String topBtnText;
  Color btnColor;
  Color btnTextColor;
  Widget content;

  WelcomeTemplate(
      {this.backgroundPath = "",
      this.topBtnText = "",
      this.midBtnText = "",
      this.bottomBtnText = "",
      this.btnColor = Colors.black,
      this.btnTextColor = Colors.white,
      this.content});
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        if (backgroundPath != "") Image.asset(backgroundPath),
        if (content != null)
          Center(
            child: SizedBox(height: 400, width: 350, child: content),
          ),
        if (topBtnText != "")
          Align(
            alignment: FractionalOffset(0.5, 0.68),
            child: welcomeButton(context, topBtnText),
          ),
        if (midBtnText != "")
          Align(
            alignment: FractionalOffset(0.5, 0.78),
            child: welcomeButton(context, midBtnText),
          ),
        if (bottomBtnText != "")
          Align(
            alignment: FractionalOffset(0.5, 0.88),
            child: welcomeButton(context, bottomBtnText),
          ),
      ],
    ));
  }

  Widget welcomeButton(BuildContext context, String text) {
    return RaisedButton(
      color: btnColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      onPressed: () {
        if (text == "Continue" || text == "SKIP")
          BlocProvider.of<WelcomePageBloc>(context)
              .dispatch(WelcomePageEvent.next);
        if (text == "Allow Health Access")
          BlocProvider.of<WelcomePageBloc>(context)
              .dispatch(WelcomePageEvent.healthAccess);
        if (text == "Allow Location Access")
          BlocProvider.of<WelcomePageBloc>(context)
              .dispatch(WelcomePageEvent.locationAccess);
      },
      elevation: 10,
      child: Container(
        height: 48,
        width: 251.6,
        alignment: Alignment.center,
        child: Text(text, style: TextStyle(color: btnTextColor, fontSize: 17.2, letterSpacing: -0.4, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class WelcomeIntro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Container(
            color: Colors.white,
            child: Stack(
              children: <Widget>[
                WelcomeTemplate(
                  backgroundPath: "images/sampleBackground.png",
                  btnColor: Colors.white,
                  btnTextColor: Color(0xFFF76C6C),
                  topBtnText: "Allow Location Access",
                  midBtnText: "Allow Health Access",
                  bottomBtnText: "Continue",
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("Welcome to",
                          style: TextStyle(
                              color: Color(0xFF989696), fontSize: 25.2, letterSpacing: -0.36, fontWeight: FontWeight.normal)),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(500),
                          image: DecorationImage(
                            image: ExactAssetImage('images/Image 3@3x.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text("S Therapy",
                          style: TextStyle(color: Colors.white, fontSize: 26, letterSpacing: -0.36, )),
                      SizedBox(height: 40),
                      Text(
                        "S-theraphy creates the perfect sound\nEnvironment for work or relaxation.",
                        style:
                            TextStyle(color: Color(0xFFA89494), fontSize: 13.2, letterSpacing: -0.2,),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}

// ignore: must_be_immutable
class WelcomeExplain extends StatelessWidget {
  Color baseColor;
  String topBtnText;
  String bottomBtnText;
  String iconPath;
  String explainTitle;
  String explain;
  WelcomeExplain(
      {this.baseColor,
      this.topBtnText = "",
      this.bottomBtnText = "",
      this.iconPath,
      this.explain,
      this.explainTitle});
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Container(
            color: Colors.white,
            child: Stack(
              children: <Widget>[
                WelcomeTemplate(
                  backgroundPath: "",
                  btnColor: baseColor,
                  btnTextColor: Colors.white,
                  topBtnText: topBtnText,
                  bottomBtnText: bottomBtnText,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 20,),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(500),
                          image: DecorationImage(
                            image: ExactAssetImage(iconPath),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(explainTitle,
                          style: TextStyle(color: baseColor, fontSize: 28, letterSpacing: -0.4, fontWeight: FontWeight.bold)),
                      SizedBox(height: 13.2),
                      Text(
                        explain,
                        style: TextStyle(color: baseColor, fontSize: 13.2, letterSpacing: -0.2),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
