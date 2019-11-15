import 'package:flutter/material.dart';
import 'package:urcab/pages/prvRidePage.dart';
import 'package:urcab/main.dart';
import 'package:urcab/pages/favRidesPage.dart';
import 'package:urcab/pages/newRidePage.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:urcab/pages/entertainment.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:flare_flutter/flare_actor.dart';

//TODO vibration and toast feedback

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //TODO build homepage
  int _sI = 1;
  List<BottomNavigationBarItem> bottomMenu = [
    BottomNavigationBarItem(
      activeIcon: Icon(Icons.history, color: Color(0xff5F1063)),
      icon: Icon(Icons.history, color: Color(0xff150316)),
      title: Text(
        "Booked Rides",
        style: TextStyle(fontSize: 12.0, color: Color(0xff5F1063)),
      ),
      backgroundColor: Color(0xffEDE4ED),
    ),
    BottomNavigationBarItem(
      activeIcon: Icon(Icons.favorite, color: Color(0xff5F1063)),
      icon: Icon(Icons.favorite_border, color: Color(0xff150316)),
      title: Text(
        "Favourite Ride",
        style: TextStyle(fontSize: 18.0, color: Color(0xff5F1063)),
      ),
      backgroundColor: Color(0xffEDE4ED),
    ),
    BottomNavigationBarItem(
      activeIcon: Icon(Icons.add_circle, color: Color(0xff5F1063)),
      icon: Icon(Icons.add_circle_outline, color: Color(0xff150316)),
      title: Text(
        "New Ride",
        style: TextStyle(fontSize: 18.0, color: Color(0xff5F1063)),
      ),
      backgroundColor: Color(0xffEDE4ED),
    ),
    BottomNavigationBarItem(
      activeIcon: Icon(Icons.play_circle_filled, color: Color(0xff5F1063)),
      icon: Icon(Icons.play_circle_outline, color: Color(0xff150316)),
      title: Text(
        "Entertainment",
        style: TextStyle(fontSize: 18.0, color: Color(0xff5F1063)),
      ),
      backgroundColor: Color(0xffEDE4ED),
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var aD = Root.of(context);
    Widget _bodyWidget() {
      if (_sI == 0) {
        return YourRides();
      } else if (_sI == 1) {
        return FavRidePage();
      } else if (_sI == 2) {
        return NewRide();
      } else {
        return Entertainment();
      }
    }

    return ShowCaseWidget(
      builder: Builder(builder: (context) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Color(0xffEDE4ED),
            //TODO build body of homePage
            appBar: AppBar(
              centerTitle: true,
              elevation: 8.0,
              backgroundColor: Color(0xffDBC9DC),
              title: Text(
                "UrCab",
                style: TextStyle(
                    color: Color(0xff0A010B),
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0),
              ),
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.help,
                      color: Color(0xff297F2F),
                      size: 40.0,
                    ),
                    onPressed: () {
                      switch (_sI) {
                        case 0:
                          {
                            _toastUC();
                            break;
                          }
                        case 1:
                          {
                            _toastUC();
                            break;
                          }
                        case 2:
                          {
                            ShowCaseWidget.of(context).startShowCase([
                              aD.setPickupKey,
                              aD.setCurrentAsPickUP,
                              aD.setDestination,
                              aD.setCurrentAsDestination,
                              aD.bookNewRide
                            ]);
                            break;
                          }
                        case 3:
                          {
                            _toastUC();
                            break;
                          }
                        default:
                          {}
                      }
                    }),
                SizedBox(width: 8.0),
              ],
            ),
            body: _bodyWidget(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: _sI != 0
                ? SizedBox(
                    height: 80.0,
                    width: 80.0,
                    child: FloatingActionButton(
                      onPressed: _launchRecordDialog,
                      backgroundColor: Color(0xff340837),
                      heroTag: "Voice",
                      child: Icon(
                        Icons.keyboard_voice,
                        size: 50.0,
                      ),
                    ),
                  )
                : null,
            bottomNavigationBar: BottomNavigationBar(
              elevation: 20.0,
              backgroundColor: Color(0xff824585),
              items: bottomMenu,
              currentIndex: _sI,
              onTap: (index) {
                setState(() {
                  _sI = index;
                });
              },
            ),
          ),
        );
      }),
    );
  }

  void _toastUC() {
    Fluttertoast.showToast(
        msg: "Under Implementation...",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color(0xff381709),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _launchRecordDialog() async {
    print(1);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          //TODO start recording here
          Root.of(context).speechResult = "";
          return new SpeechDialog();
        });
  }
}

class SpeechDialog extends StatefulWidget {
  @override
  _SpeechDialogState createState() => _SpeechDialogState();
}

class _SpeechDialogState extends State<SpeechDialog> {
  SpeechRecognition _speech;
  bool _speechAvail = false, _speechListening = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    speechInitState();
  }

  void speechInitState() async {
    _speech = SpeechRecognition();

    _speech.setAvailabilityHandler((val) {
      setState(() {
        _speechAvail = val;
      });
    });

    _speech.activate().then((val) {
      setState(() {
        _speechAvail = val;
      });
    });

    _speech.setRecognitionStartedHandler(() {
      setState(() {
        _speechListening = true;
      });
    });

    _speech.setRecognitionCompleteHandler(() {
      setState(() {
        _speechListening = false;
      });
    });

    _speech.setRecognitionResultHandler((res) {
      setState(() {
        Root.of(context).speechResult = res;
      });
    });

    await _speech
        .listen(locale: "en_US")
        .catchError((e) => print("Error" + e.toString()))
        .then((res) => print("result: " + res.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xffE4EFE5),
      contentPadding: EdgeInsets.symmetric(vertical: 24.0),
      elevation: 10.0,
      title: Text(
        "Listening...",
        style: TextStyle(
            color: Color(0xff0A010B),
            fontWeight: FontWeight.bold,
            fontSize: 24.0),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      content: SizedBox(
        height: 40.0,
        width: 40.0,
        child: Center(
          child: _speechListening
              ? FlareActor(
                  "lib/assets/listening_4.flr",
                  fit: BoxFit.cover,
                  animation: "listening",
                )
              : Text(Root.of(context).speechResult),
        ),
      ),
      actions: <Widget>[
        ButtonBar(
          alignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            RaisedButton(
              color: Color(0xffE4EFE5),
              elevation: 0.0,
              onPressed: () async {
                //TODO stop the recorder
                //TODO dismiss the alert box
                await _speech.cancel();
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Color(0xff702E12)),
              ),
            ),
            RaisedButton(
              color: Color(0xff448F49),
              onPressed: () async {
                //TODO stop the recorder and save the recorded response
                //TODO call the voice speech to text api
                //TODO determine next action after inspecting the string
                //TODO in case of success and failure show appropriate message
                await _speech.stop();
                Navigator.of(context).pop();
              },
              child: Text(
                "Proceed",
                style: TextStyle(color: Color(0xffE4EFE5)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
