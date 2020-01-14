import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sound_therapy/Component/ModeButton.dart';
import 'package:sound_therapy/Module/FireBase.dart';
import 'package:sound_therapy/View/Background/BackgroundTemplate.dart';

import 'Component/CustomAnimatedSplash.dart';
import 'View/MusicControlPage.dart';
import 'View/WelcomePage.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class CustomImageCache extends WidgetsFlutterBinding {
  @override
  ImageCache createImageCache() {
    ImageCache imageCache = super.createImageCache();
    // Set your image cache size
    imageCache.maximumSizeBytes = 1024 * 1024 * 512; // 100 MB
    return imageCache;
  }
}


void main() {
  CustomImageCache();
  Function duringSplash = (context) {
    BackgroundTemplate.preloadBg(context);
    print('Something background process');
    SharedPreferences.getInstance().then((prefs) {
      bool isFirst = prefs.getBool("isFirst") ?? true;
      print("is first run[$isFirst]");
      MusicControlPage.isFirst = isFirst;
    });
    FireBase.instance.silentlySignIn();
    return 1;
  };

  Map<int, Widget> op = {1: App()};

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CustomAnimatedSplash(
      imagePath: 'images/loading_page.jpg',
      home: App(),
      customFunction: duringSplash,
      duration: 2500,
      type: AnimatedSplashType.BackgroundProcess,
      outputAndHome: op,
    ),
  ));

  // App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  String initPage = '/Welcome';
  @override
  void initState() {
    super.initState();
    initPage = '/';
    if (MusicControlPage.isFirst) initPage = '/Welcome';
   }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WelcomePageBloc>(
          builder: (context) => WelcomePageBloc(),
        ),
        BlocProvider<ModeChangeBloc>(
          builder: (context) => ModeChangeBloc(),
        ),
        BlocProvider<UtilButtonBloc>(
          builder: (context) => UtilButtonBloc(),
        ),
      ],
      child: MaterialApp(
      theme: new ThemeData(canvasColor: Colors.transparent),
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      initialRoute: initPage,
      routes: {
        '/Welcome': (BuildContext context) => WelcomeView(),
        '/': (BuildContext context) => MusicControlPage(),
      },
    ),
    );
  }
}
