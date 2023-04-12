// ignore: import_of_legacy_library_into_null_safe
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/emotions/happy.dart';
import 'package:flutter_dev/emotions/sad.dart';
import 'package:flutter_dev/emotions/surprise.dart';
import 'package:flutter_dev/history.dart';
import 'package:flutter_dev/homePage.dart';

List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Dynamic',
        theme: ThemeData(
            backgroundColor: Colors.black,
            primaryColor: Colors.amber.shade200,
            buttonColor: Colors.blueGrey),
        debugShowCheckedModeBanner: false,
        home: HomePage(),
        routes: {
          "homePage": (context) => HomePage(),
          "happy": (context) => Happy(),
          "sad": (context) => Sad(),
          "surprise": (context) => Surprise(),
          "history": (context) => History(),
        });
  }
}
