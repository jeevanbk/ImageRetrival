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
  ImagesViewModel imagesViewModel = new ImagesViewModel();

  void initState() {
    // TODO: implement initState
    super.initState();
    imagesViewModel = Provider.of<ImagesViewModel>(context, listen: false);
    loadWidget();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 120,
            margin: EdgeInsets.only(top: 80, bottom: 30),
            child:
                Container(), /*SvgPicture.asset(
              "assets/images/splash_icon.svg",
            ),*/
          ),
          Text(
            "Excelledia",
            style: TextStyle(
                fontFamily: "Nunito",
                fontSize: 20,
                color: Color(0xff000000),
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  void checkIsLogin() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ChangeNotifierProvider(
                create: (context) => ImagesViewModel(), child: SearchImage())),
        (route) => false);
  }

  loadWidget() async {
    var _duration = Duration(seconds: 3);
    return Timer(_duration, checkIsLogin);
  }
}
