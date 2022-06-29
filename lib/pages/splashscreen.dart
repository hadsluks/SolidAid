import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:urcab/pages/DataBase.dart';
import 'package:urcab/pages/introslider.dart';
import 'package:urcab/pages/home.dart';

class AppSplashScreen extends StatefulWidget {
  @override
  _AppSplashScreenState createState() => _AppSplashScreenState();
}

class _AppSplashScreenState extends State<AppSplashScreen> {
  DBHelper db = new DBHelper();
  Future<bool> isFirst() async {
    firstInstall = await db.firstInstall();
    return firstInstall;
  }

  bool firstInstall;
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 1,
      photoSize: 125.0,
      loaderColor: Color(0xffDBC9DC),
      title: Text(
        "UrCab",
        style: TextStyle(fontSize: 30),
      ),
      image: Image.asset("lib/assets/SplashScreen.png"),
      navigateAfterSeconds: FutureBuilder(
        future: isFirst(),
        builder: (context, sp) {
          if (sp.hasData) {
            if (firstInstall)
              return AppIntroSlider();
            else
              return Home();
          } else {
            return SizedBox(
              height: 60,
              width: 60,
              /* child: CircularProgressIndicator(
                backgroundColor: Color(0xffDBC9DC),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff702A74)),
              ), */
            );
          }
        },
      ),
    );
  }
}
