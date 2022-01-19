import 'dart:async';
import 'package:excelledia/Model/images_model.dart';
import 'package:excelledia/View/image_search.dart';
import 'package:excelledia/ViewModel/images_view_model.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

@override
class _SplashState extends State<Splash> {

  void initState() {
    // TODO: implement initState
    super.initState();
    loadWidget();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
        child: Container(
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: "Excelledia",
                    style: TextStyle(color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 24)),
                TextSpan(
                    text:"Ventures.",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 24,
                      fontWeight:  FontWeight.w500,)),
              ]),
            )),
      ),
    );
  }

  void navigationToDashboard() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ChangeNotifierProvider(
                create: (context) => ImagesViewModel(), child: Dashboard())),
        (route) => false);
  }

  loadWidget() async {
    var _duration = Duration(seconds: 3);
    return Timer(_duration, navigationToDashboard);
  }
}
