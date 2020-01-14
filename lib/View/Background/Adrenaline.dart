import 'package:flutter/material.dart';

class AdrenalineBackground extends StatefulWidget {
  @override
  _AdrenalineBackgroundState createState() => _AdrenalineBackgroundState();
}

class _AdrenalineBackgroundState extends State<AdrenalineBackground> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.green
          ),
        ),
        Container(
          child: SizedBox(
            width: 500,
            height: 500,
            child: new Image(
              image: new AssetImage("images/like_anim.gif"),
              width: 400,
              height: 400,
              fit: BoxFit.contain,
              )
          )
        )
      ],
    );
  }
}
