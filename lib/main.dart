import 'package:excelledia/Model/images_model.dart';
import 'package:excelledia/View/splash_screen.dart';
import 'package:excelledia/ViewModel/images_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ImagesViewModel()),
        ],
        child: MaterialApp(
            theme: ThemeData(fontFamily: "fonts/Nunito-Bold.ttf"),
            title: 'Excelledia',
            debugShowCheckedModeBanner: false,
            home: Splash()));
  }
}
