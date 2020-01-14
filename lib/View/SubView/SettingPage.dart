import 'package:flutter/material.dart';
import 'package:sound_therapy/Component/CustomRaisedButton.dart';
import 'package:sound_therapy/Module/FireBase.dart';
import 'package:sound_therapy/Module/Purchase.dart';
import 'package:sound_therapy/Module/STFitnessGetter.dart';
import 'package:sound_therapy/Module/STWeatherGetter.dart';


// ignore: must_be_immutable
class SettingPage extends StatefulWidget {
  STFitnessGetter fitnessGetter;
  STWeatherGetter weatherGetter;
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Purchase _purchase;
  @override
  void initState() {
    super.initState();
    widget.fitnessGetter = STFitnessGetter();
    widget.weatherGetter = STWeatherGetter();

    FireBase.instance.setUserStateChagedCb(() => setState((){}));
    _purchase = Purchase();
    _purchase.startListener();
    _purchase.setOnPurchased((){
      FireBase.instance.add();
    });
  }
  @override
  void dispose() {
    print("dispose");
    FireBase.instance.setUserStateChagedCb(null);
    _purchase.stopListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Align(
            alignment: FractionalOffset(0.95, 0.02),
            child: IconButton(
              icon: Icon(Icons.close, color: Color(0xFF757575)),
              onPressed: () => Navigator.pop(context),
              iconSize: 25, //12
              splashColor: Colors.black,
            )),
        Align(
          alignment: FractionalOffset(0.5, 0.1),
          child: Text(
            "Setting",
            style: TextStyle(
                color: Color(0xa2312c2c),
                fontSize: 25,
                fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 120, 20, 20),
          child: ListView(
            children: <Widget>[
              _getSubtitle("Account"),
              if (FireBase.instance.isSignedIn() == false) _getSettingButton("Sign In", FireBase.instance.signIn, false),
              if (FireBase.instance.isSignedIn() == true) _getSignedUserData(),
              _getSubtitle("Data Access"),
              _getSubtitleExplain(
                  "S Therapy uses the following data to\nPersonalize and adapt sounds in real-time"),
              _getSettingButton("Location Access Allowed",
                  widget.weatherGetter.requestPermission, false),
              _getSettingButton("Health Access Allowed",
                  widget.fitnessGetter.requestPermission, false),
              _getSubtitle("Data Management"),
              _getSubtitleExplain(
                  "You can export or delete your personal\nData from our systems"),
              _getSettingButton("Remove My personal data", FireBase.instance.delete, true),
            ],
          ),
        )
      ],
    );
  }

  Widget _getSignedUserData() {
    print("photo url : ${FireBase.instance.getUserPhotoUrl()}");
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 12, right: 20),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              image: DecorationImage(
                image: NetworkImage(FireBase.instance.getUserPhotoUrl()),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(FireBase.instance.getUserDisPlayName(),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    )),
                Text("Subscribed on Android",
                    style: TextStyle(
                      fontSize: 17,
                    ))
              ],
            ),
          ),
          RawMaterialButton(
            onPressed: FireBase.instance.signOut,
            child: new Icon(
              Icons.exit_to_app,
              color: Color(0xFFF89F9F),
              size: 30.0,
            ),
            shape: CircleBorder(),
            elevation: 10.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(10.0),
          ),
        ],
      ),
    );
  }
  Container _getSubtitleExplain(String explain) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        explain,
        style: TextStyle(color: Color(0xFF484646), fontSize: 18),
      ),
    );
  }

  Widget _getSettingButton(String title, Function func, bool fillBackground) {
    Color bgColor = Colors.white;
    Color textColor = Colors.black;
    Color borderColor = Color(0xFFFF7BA3);
    if (fillBackground) bgColor = Color(0xFFFF7BA3);
    if (fillBackground) textColor = Colors.white;
    if (func == null) borderColor = Colors.white;
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: CustomRaisedButton(
        bgColor: bgColor,
        borderColor: borderColor,
        textColor: textColor,
        text: title,
        elevation: 0,
        height: 60,
        width: 300,
        onPressed: func,
      ),
    );
  }

  Widget _getSubtitle(String title) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                color: Color(0xFF484646),
                fontSize: 20,
                fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Divider(
              color: Color(0xFFCECECE),
              indent: 10,
            ),
          ),
        ],
      ),
    );
  }
}
