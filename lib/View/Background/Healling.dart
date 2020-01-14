import 'package:flutter/material.dart';

class Healling extends StatefulWidget {
  @override
  _HeallingState createState() => _HeallingState();
}

class _HeallingState extends State<Healling>
    with SingleTickerProviderStateMixin {
      Decoration first;
      Decoration second;
      Container test1;
      Container test2;
  @override
  void initState() {
    super.initState();
    first = BoxDecoration(
            
            gradient: LinearGradient(colors: [Colors.amber, Colors.blue])
          );
    second = BoxDecoration(
            
            gradient: RadialGradient(colors: [Colors.amber, Colors.blue])
          );
          test1 = Container(
            decoration: first,
          );
          test2 = Container(
            decoration: second,
          );
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
        AnimatedContainer(
          duration: Duration(seconds: 2),
          decoration: first,
          foregroundDecoration: second,
        ),
      ],
    );
  }
}
