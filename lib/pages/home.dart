import 'package:flutter/material.dart';
import 'package:urcab/pages/prvRidePage.dart';
import 'package:urcab/main.dart';
import 'package:urcab/pages/favRidesPage.dart';
import 'package:urcab/pages/newRidePage.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:urcab/pages/entertainment.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:urcab/pages/SetPickUpLocation.dart';
import 'package:urcab/pages/entertainment.dart';

//TODO vibration and toast feedback

GlobalKey a = GlobalKey();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //TODO build homepage
  int _sI = 0;
  List<BottomNavigationBarItem> bottomMenu = [
    BottomNavigationBarItem(
      activeIcon: Image.asset(
        "lib/assets/yt.png",
        height: 24,
        width: 24,
        colorBlendMode: BlendMode.overlay,
      ), //Icon(Icons.play_circle_filled, color: Color(0xff5F1063)),
      icon: Image.asset(
        "lib/assets/yt.png",
        height: 28,
        width: 28,
      ), //Icon(Icons.play_circle_outline, color: Color(0xff150316)),
      title: Text(
        "Videos",
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
      activeIcon: Icon(Icons.favorite, color: Color(0xff5F1063)),
      icon: Icon(Icons.favorite_border, color: Color(0xff150316)),
      title: Text(
        "Favourite",
        style: TextStyle(fontSize: 18.0, color: Color(0xff5F1063)),
      ),
      backgroundColor: Color(0xffEDE4ED),
    ),
    BottomNavigationBarItem(
      activeIcon: Icon(Icons.history, color: Color(0xff5F1063)),
      icon: Icon(Icons.history, color: Color(0xff150316)),
      title: Text(
        "Booked Ride",
        style: TextStyle(fontSize: 12.0, color: Color(0xff5F1063)),
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
      if (_sI == 3) {
        return YourRides();
      } else if (_sI == 2) {
        return FavRidePage();
      } else if (_sI == 1) {
        return NewRide();
      } else if (_sI == 0) {
        return Entertainment();
      }
    }

    return ShowCaseWidget(
      builder: Builder(builder: (context) {
        return SafeArea(
          child: Scaffold(
            //backgroundColor: Color(0xffEDE4ED),
            //TODO build body of homePage
            appBar: AppBar(
              centerTitle: true,
              elevation: 8.0,
              backgroundColor: Color(0xffDBC9DC),
              title: Text(
                _sI == 0 ? "Entertainment" : "UrCab",
                style: TextStyle(
                    color: Color(0xff0A010B),
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0),
              ),
              actions: <Widget>[
                _sI == 1
                    ? IconButton(
                        icon: Icon(
                          Icons.help,
                          color: Color(0xff297F2F),
                          size: 40.0,
                        ),
                        onPressed: () {
                          switch (_sI) {
                            case 0:
                              {
                                Root.of(context)
                                    .toast("Under Implementation...");
                                break;
                              }
                            case 2:
                              {
                                Root.of(context)
                                    .toast("Under Implementation...");
                                break;
                              }
                            case 1:
                              {
                                ShowCaseWidget.of(context).startShowCase([
                                  aD.setPickupKey,
                                  aD.setCurrentAsPickUP,
                                  aD.setDestination,
                                  aD.setCurrentAsDestination,
                                  aD.bookNewRide,
                                  aD.voiceButton
                                ]);
                                break;
                              }
                            case 3:
                              {
                                Root.of(context)
                                    .toast("Under Implementation...");
                                break;
                              }
                            default:
                              {}
                          }
                        },
                      )
                    : SizedBox(),
                SizedBox(width: 8.0),
              ],
            ),
            body: _bodyWidget(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: _sI == 0 || _sI == 1
                ? SizedBox(
                    height: 80.0,
                    width: 80.0,
                    child: Showcase(
                      key: Root.of(context).voiceButton,
                      description: "Click me and Speak",
                      child: FloatingActionButton(
                        onPressed: _launchRecordDialog,
                        backgroundColor: Color(0xff340837),
                        heroTag: "Voice",
                        child: Icon(
                          Icons.keyboard_voice,
                          size: 50.0,
                        ),
                      ),
                    ))
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

  void _launchRecordDialog() async {
    PermissionStatus permStatus = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.microphone);
    if (permStatus.value == 0) {
      await PermissionHandler()
          .requestPermissions([PermissionGroup.microphone]);
    }
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          //TODO start recording here
          Root.of(context).speechResult = "";
          return new SpeechDialog(
            sI: _sI,
          );
        });
  }
}

class SpeechDialog extends StatefulWidget {
  int sI;
  SpeechDialog({this.sI});
  @override
  _SpeechDialogState createState() => _SpeechDialogState();
}

class _SpeechDialogState extends State<SpeechDialog> {
  void speechRes() async {
    String res = Root.of(context).speechResult.toLowerCase();
    if (Root.of(context).speechResult.toLowerCase().contains("pickup") ||
        Root.of(context).speechResult.toLowerCase().contains("pick up")) {
      if (Root.of(context).speechResult.toLowerCase().contains("as") ||
          Root.of(context).speechResult.toLowerCase().contains("to")) {
        Navigator.of(context).pop();
        Root.of(context).setPickup = true;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SetPickUpLocation(
                      searchKey: Root.of(context)
                              .speechResult
                              .toLowerCase()
                              .contains("as")
                          ? res.split("as")[1]
                          : res.split("to")[1],
                    )));
      } else {
        Navigator.of(context).pop();
        Root.of(context).setPickup = true;
        Navigator.of(context).pushNamed('setpickuplocation');
      }
    } else if (Root.of(context)
        .speechResult
        .toLowerCase()
        .contains("destination")) {
      if (Root.of(context).pickUpLL != null) {
        Navigator.of(context).pop();
        Root.of(context).setPickup = false;
        if (Root.of(context).speechResult.toLowerCase().contains("as") ||
            Root.of(context).speechResult.toLowerCase().contains("to")) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SetPickUpLocation(
                        searchKey: Root.of(context)
                                .speechResult
                                .toLowerCase()
                                .contains("as")
                            ? res.split("as")[1]
                            : res.split("to")[1],
                      )));
        } else {
          Navigator.of(context).pushNamed('setpickuplocation');
        }
      } else {
        Root.of(context).toast("Set PickUp Location First");
      }
    } else if (Root.of(context).speechResult.toLowerCase().contains("book") ||
        Root.of(context).speechResult.toLowerCase().contains("confirm")) {
      if (Root.of(context).pickUpLL == null)
        Root.of(context).toast("Set PickUp Location First");
      else if (Root.of(context).dropOffLL == null)
        Root.of(context).toast("Set Drop Location First");
      else {
        launch(
            "https://m.uber.com/ul/?client_id=CI51-MLco_RasO6JzweBuw2XCCkm4XDw&action=setPickup&pickup[latitude]=${Root.of(context).pickUpLL.latitude}&pickup[longitude]=${Root.of(context).pickUpLL.longitude}&dropoff[latitude]=${Root.of(context).dropOffLL.latitude}&dropoff[longitude]=${Root.of(context).dropOffLL.longitude}");
        Navigator.of(context).pop();
      }
    } else if (Root.of(context).speechResult.toLowerCase().contains("play")) {
      String s = Root.of(context).speechResult.toLowerCase().split("play ")[1];
      Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Entertainment(
          searchKey: s,
        );
      }));
    } else {
      FlutterTts tts = new FlutterTts();
      await tts.setSpeechRate(0.8);
      await tts.setPitch(1.2);
      if (Root.of(context).speechResult == "" ||
          Root.of(context).speechResult == null) {
        tts.speak("Please, Say Something");
        Root.of(context).toast(":(  Please, Say Something");
      } else {
        tts.speak("Couldn't understand! Please Say again...");
        Root.of(context).toast(":( Please Say again...");
      }
    }
  }

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
        _speechListening
            ? "Listening ..."
            : (Root.of(context).speechResult.length > 0
                ? "Is this OK?"
                : "Please Retry....."),
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
              : Text(Root.of(context).speechResult,
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
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
              child: Text(
                "Retry",
                style: TextStyle(
                  color: Color(0xff150316),
                ),
              ),
              color: Color(0xffDBC9DC),
              onPressed: () async {
                await _speech
                    .listen(locale: "en_US")
                    .catchError((e) => print("Error" + e.toString()))
                    .then((res) => print("result: " + res.toString()));
              },
            ),
            RaisedButton(
              color: Color(0xff448F49),
              onPressed: () async {
                //TODO stop the recorder and save the recorded response
                //TODO call the voice speech to text api
                //TODO determine next action after inspecting the string
                //TODO in case of success and failure show appropriate message
                await _speech.stop();
                speechRes();
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
