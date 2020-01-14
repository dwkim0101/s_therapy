import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomSwitch extends StatefulWidget {
  final ValueChanged<bool> onChanged;
  bool value;
  CustomSwitch({
    @required this.value,
    @required this.onChanged,
  });
  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  Duration _duration = Duration(milliseconds: 370);
  Animation<Alignment> _animation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: _duration);
    
    AlignmentGeometry start = widget.value ? Alignment.centerRight : Alignment.centerLeft;
    AlignmentGeometry end = widget.value ? Alignment.centerLeft : Alignment.centerRight;
    _animation =
        AlignmentTween(begin: start, end: end)
            .animate(
      CurvedAnimation(
          parent: _animationController,
          curve: Curves.bounceOut,
          reverseCurve: Curves.bounceIn),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          width: 48,
          height: 32,
          decoration: BoxDecoration(
            color: widget.value ? Colors.greenAccent : Colors.grey,
            borderRadius: BorderRadius.all(
              Radius.circular(40),
            ),
          ),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: _animation.value,
                child: GestureDetector(
                  onTap: () {
                    widget.value = !widget.value;
                    widget.onChanged(widget.value);
                    setState(() {
                      if (_animationController.isCompleted) {
                        _animationController.reverse();
                      } else {
                        _animationController.forward();
                      }
                    });
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5,
                              offset: Offset(0, 0))
                        ]),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
