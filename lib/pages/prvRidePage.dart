//TODO implement previous ride page section of the home page. Scaffold is built at homw page. no need to build it here

//TODO implement previous ride page section of the home page. Scaffold is built at home page. no need to build it here
//TODO store the list of previous ride in sql locally
//TODO retrieve the list from sql on build of widget
//TODO update the list from app to sql after every ride is booked
//TODO add clear all rides button to clear the pages
//TODO showcase view of the page
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:urcab/pages/utilityWidget.dart';
import 'package:urcab/pages/DataBase.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:urcab/main.dart';

class YourRides extends StatefulWidget {
  @override
  _YourRidesState createState() => _YourRidesState();
}

class _YourRidesState extends State<YourRides> {
  var db = new DBHelper();
  List<Ride> prevRides;

  Future<List<Ride>> setPrevRides() async {
    var list = await db.getHistory();
    prevRides = [];
    list.forEach((h) {
      prevRides.add(new Ride(
        pickUpAddress: h['PICKUP_ADD'],
        destinationAddress: h['DROP_ADD'],
        pickUpLat: double.parse(h['PICKUP_LAT']),
        pickUpLng: double.parse(h['PICKUP_LNG']),
        dropOffLat: double.parse(h['DROP_LAT']),
        dropOffLng: double.parse(h['DROP_LNG']),
        estimatedCost: 0.0,
        //TODO add estimated cost..
        bookedOn: h['BOOKED_DATE'],
      ));
    });
    //TODO sort the list according to latest date first
    //prevRides = prevRides.reversed;
    return prevRides;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: setPrevRides(),
        builder: (c, s) {
          if (s.hasData) {
            if (prevRides.length == 0) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: FlareActor(
                        "lib/assets/notfound.flr",
                        fit: BoxFit.cover,
                        animation:
                            "not found", //TODO set animation string of this
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    SizedBox(
                      width: 200,
                      child: AutoSizeText(
                        "There are no rides booked yet...",
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        minFontSize: 24,
                      ),
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
            } else {
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: prevRides.length,
                itemBuilder: (c, i) => RideCard(
                  ride: prevRides[i],
                ),
              );
            }
          } else
            return Center(
                child: SizedBox(
              height: 60,
              width: 60,
              child: FlareActor(
                  "lib/assets/Loading3.flr",
                  fit: BoxFit.cover,
                  animation: "Loading",
                )
            ));
        },
      ),
    );
  }
}

class Ride {
  final String pickUpAddress;
  final String destinationAddress;
  final String bookedOn;
  final double
      estimatedCost; //TODO can we get an exact fare after the ride ends?
  final String rideType;
  double pickUpLat, pickUpLng, dropOffLat, dropOffLng;

  Ride(
      {this.pickUpAddress,
      this.destinationAddress,
      this.bookedOn,
      this.estimatedCost = 0.0,
      this.rideType = "",
      this.dropOffLat,
      this.dropOffLng,
      this.pickUpLat,
      this.pickUpLng});
}

class RideCard extends StatelessWidget {
  final Ride ride;

  const RideCard({Key key, this.ride}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xfffeeee7),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: AutoSizeText(
                      ride.pickUpAddress,
                      maxLines: 5,
                      minFontSize: 18,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Icon(Icons.arrow_forward),
                  ),
                  Expanded(
                    flex: 3,
                    child: AutoSizeText(
                      ride.destinationAddress,
                      maxLines: 5,
                      minFontSize: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.calendar_today,
                            size: 24.0,
                          ),
                          SizedBox(
                            height: 40,
                            width: 8,
                          ),
                          AutoSizeText(
                            ride.bookedOn,
                            maxLines: 1,
                            minFontSize: 22,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  /*Expanded(
                    flex: 3,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            Icons.attach_money,
                            size: 24.0,
                          ),
                          Text(
                            ride.estimatedCost.toString(),
                            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )*/
                ],
              )
            ],
          )),
    );
  }
}
