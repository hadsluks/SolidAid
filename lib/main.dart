import 'package:flutter/material.dart';
import 'package:urcab/pages/home.dart';
import 'pages/SetPickUpLocation.dart';
import 'pages/newRidePage.dart';
import 'package:urcab/pages/bookRidePage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:urcab/pages/entertainment.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'pages/splashscreen.dart';

void main() =>
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) {
      runApp(MyApp());
    });

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  @override
  Widget build(BuildContext context) {
    return Root(
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'Montserrat'),
        debugShowCheckedModeBanner: false,
        title: 'UrCab',
        routes: {
          'home': (BuildContext context) => Home(),
          'newride': (BuildContext context) => NewRide(),
          'setpickuplocation': (BuildContext context) => SetPickUpLocation(),
          'bookride': (BuildContext context) => BookRide(),
          'entertainment': (BuildContext context) => Entertainment(),
          'splashscreen': (BuildContext context) => AppSplashScreen(),
        },
        initialRoute: 'splashscreen',
      ),
    );
  }
}

class Root extends InheritedWidget {
  Root({
    Key key,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);
  double fontSize = 20.0;
  LatLng pickUpLL, dropOffLL;
  String rideType = "";
  bool setPickup = false;
  int tabIndex = 1;
  int selectedIndex = 2;
  String videosearch;
  TabController bookRideController;
  String speechResult = "";
  GlobalKey mapCurrentLocationKey = GlobalKey();
  GlobalKey mapSearchBar = GlobalKey();
  GlobalKey mapConfirmKey = GlobalKey();
  GlobalKey setPickupKey = GlobalKey();
  GlobalKey setCurrentAsPickUP = GlobalKey();
  GlobalKey setDestination = GlobalKey();
  GlobalKey setCurrentAsDestination = GlobalKey();
  GlobalKey setRideType = GlobalKey();
  GlobalKey bookNewRide = GlobalKey();
  GlobalKey voiceButton = GlobalKey();
  void toast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color(0xff381709),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static Root of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(Root) as Root;
  }

  @override
  bool updateShouldNotify(Root old) => true;
}

//TODO launch intro_slider on only first launch
//TODO define file tree
//TODO get app launcher code
//TODO add color pallet in [Root]
//TODO themedata
//TODO implement Showcase view for all the page throughout the app
