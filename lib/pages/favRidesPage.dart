import 'package:flutter/material.dart';
import 'package:urcab/pages/DataBase.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:urcab/main.dart';

class FavRides {
  String pickUpAdd, dropOffAdd;
  double pickUpLat, pickUpLng, dropOffLat, dropOffLng;
}

class FavRidePage extends StatefulWidget {
  const FavRidePage({Key key}) : super(key: key);

  @override
  _FavRidePageState createState() => _FavRidePageState();
}

class _FavRidePageState extends State<FavRidePage> {
  var db = new DBHelper();
  List<FavRides> favRides = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<List<FavRides>> setFavRides() async {
    favRides = [];
    var list = await db.getAllFav();
    list.forEach((f) {
      FavRides fr = new FavRides();
      fr.pickUpAdd = f['PICKUP_ADD'];
      fr.pickUpLat = double.parse(f['PICKUP_LAT']);
      fr.pickUpLng = double.parse(f['PICKUP_LNG']);
      fr.dropOffAdd = f['DROP_ADD'];
      fr.dropOffLat = double.parse(f['DROP_LAT']);
      fr.dropOffLng = double.parse(f['DROP_LNG']);
      favRides.add(fr);
    });
    return favRides;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: setFavRides(),
      builder: (c, s) {
        if (s.hasData) {
          return Center(
            child: favRides.length > 0
                ? ListView.builder(
                    itemCount: favRides.length,
                    itemBuilder: (context, i) => Card(
                      color: Color(0xfffeeee7),
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: AutoSizeText(
                                      favRides[i].pickUpAdd,
                                      maxLines: 5,
                                      minFontSize: 20,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Icon(Icons.arrow_forward),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: AutoSizeText(
                                      favRides[i].dropOffAdd,
                                      maxLines: 5,
                                      minFontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: Colors.transparent,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      color: Color(0xffc45120),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.delete,
                                            color: Color(0xfffeeee7),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            "Remove",
                                            style: TextStyle(
                                                color: Color(0xfffeeee7)),
                                          ),
                                        ],
                                      ),
                                      onPressed: () async {
                                        await db.removeFav(favRides[i]);
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: Colors.transparent,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      color: Color(0xff297f2f),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.directions_car,
                                            color: Color(0xffe4efe5),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            "Book",
                                            style: TextStyle(
                                                color: Color(0xffe4efe5),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0),
                                          ),
                                        ],
                                      ),
                                      onPressed: () {
                                        launch(
                                            "https://m.uber.com/ul/?client_id=CI51-MLco_RasO6JzweBuw2XCCkm4XDw&action=setPickup&pickup[latitude]=${favRides[i].pickUpLat}&pickup[longitude]=${favRides[i].pickUpLng}&dropoff[latitude]=${favRides[i].dropOffLat}&dropoff[longitude]=${favRides[i].dropOffLng}");
                                      },
                                    ),
                                  )
                                ],
                              )
                            ],
                          )),
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: FlareActor(
                          "lib/assets/notfound.flr",
                          fit: BoxFit.cover,
                          animation: "not_found",
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      SizedBox(
                        width: 200,
                        child: AutoSizeText(
                          "There are no favourite rides yet...",
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          minFontSize: 24,
                        ),
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
/*
                      SizedBox(
                        height: 50,
                        child: RaisedButton(
                          color: Color(0xffC9DFCB),
                          shape: StadiumBorder(side: BorderSide(color: Color(0xff0F7016))),
                          onPressed: () {
                            setState(() {
                              //TODO implement jump to new ride
                              aD.selectedIndex = 2;
                              print(aD.selectedIndex);
                            });
                          },
                          child: Text("Book a new ride",style: TextStyle(color: Color(0xff083E0C)),),
                        ),
                      )
*/
                    ],
                  ),
          );
        } else
          return Center(
            child: SizedBox(
              child: FlareActor(
                "lib/assets/Loading3.flr",
                fit: BoxFit.cover,
                animation: "Loading",
              ),
              height: 50,
              width: 50,
            ),
          );
      },
    );
  }
}
