// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unnecessary_this

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trans4/constants/constants.dart';
import 'package:trans4/ui/widgets/color_loader.dart';
import 'package:is_first_run/is_first_run.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;

  AnimationController animationController;
  Animation<double> animation;

  startTime() async {
    var _duration = const Duration(seconds: 4);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    bool ifc = await IsFirstRun.isFirstCall();
    if (ifc) {
      Navigator.of(context).pushReplacementNamed(INTRO);
    } else {
      Navigator.of(context).pushReplacementNamed(SIGN_IN);
    }
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 4));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: 150.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      ColorLoader2(
                        color1: Colors.redAccent,
                        color2: Colors.deepPurple,
                        color3: Colors.green,
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Text(
                        'IN CONFIDENTIALITY WE BELIEVE',
                        style: TextStyle(
                            fontSize: 17.0,
                            fontFamily: 'Courgette',
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[500],
                            letterSpacing: 1.8),
                      ),
                    ],
                  ))
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 220,
              ),
              Image.asset(
                'assets/images/logo.png',
                width: animation.value * 250,
                height: animation.value * 250,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
