//TODO implement book new Ride page here, will need to integrate google map and gps location, and search in map functionality
//TODO create separate files as necessary.
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:urcab/main.dart';
import 'package:selectable_circle/selectable_circle.dart';
import 'package:geocoder/geocoder.dart';
import 'package:urcab/pages/favRidesPage.dart';
import 'package:urcab/pages/DataBase.dart';
import 'package:urcab/pages/prvRidePage.dart';
import 'package:intl/intl.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:url_launcher/url_launcher.dart';

class NewRide extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NewRideState();
  }
}

class NewRideState extends State<NewRide> {
  var db = new DBHelper();

  @override
  Widget build(BuildContext context) {
    var aD = Root.of(context);
    // TODO: implement build
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            height: 50.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Opacity(
                  opacity: aD.pickUpLL != null ? 1 : 0.2,
                  child: SelectableCircle(
                    color: Color(0xffEDE4ED),
                    selectedColor: Color(0xff448f49),
                    selectedBorderColor: Color(0xff0f7016),
                    child: aD.pickUpLL != null ? Icon(Icons.check) : null,
                    width: 50,
                    isSelected: aD.pickUpLL != null,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Showcase(
                  key: aD.setPickupKey,
                  title: "Select the pickup location",
                  description: aD.setPickup
                      ? "Say \"Change Pick Up Location\""
                      : "Say \"Select Pick Up Location\"",
                  child: RaisedButton(
                    color: Color(0xffC9DFCB),
                    shape: StadiumBorder(
                        side: BorderSide(color: Color(0xff0F7016))),
                    child: SizedBox(
                      child: Center(
                        child: Text(
                          aD.pickUpLL != null
                              ? "Change Pickup Location"
                              : "Select Pickup Location",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xff083E0C), fontSize: 18.0),
                        ),
                      ),
                      height: 60,
                    ),
                    onPressed: () {
                      aD.setPickup = true;
                      Navigator.of(context).pushNamed('setpickuplocation');
                    },
                  ),
                ),
              ),
              Expanded(
                child: Showcase(
                  title: "Set Current Location as Pick Up",
                  description: "Say \"Set Current Location as Pick Up\"",
                  key: aD.setCurrentAsPickUP,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: FloatingActionButton(
                      heroTag: "Pickup",
                      backgroundColor: Color(0xffC9DFCB),
                      child: Icon(
                        Icons.my_location,
                        color: Color(0xff083E0C),
                      ),
                      onPressed: () async {
                        var loc = await Location().getLocation();
                        setState(() {
                          aD.pickUpLL = new LatLng(loc.latitude, loc.longitude);
                        });
                      },
                    ),
                  ),
                ),
                flex: 1,
              ),
            ],
          ),
          SizedBox(
            height: 50.0,
          ),
          Opacity(
            opacity: aD.pickUpLL != null ? 1 : 0.4,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Opacity(
                    opacity: aD.dropOffLL != null ? 1 : 0.4,
                    child: SelectableCircle(
                      color: Color(0xffEDE4ED),
                      selectedColor: Color(0xff448f49),
                      selectedBorderColor: Color(0xff0f7016),
                      child: aD.dropOffLL != null ? Icon(Icons.check) : null,
                      width: 50,
                      isSelected: aD.dropOffLL != null,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Showcase(
                    key: aD.setDestination,
                    title: "Select the destination location",
                    description: aD.dropOffLL != null
                        ? "Say \"Change Destination Location\""
                        : "Say \"Select Destination Location\"",
                    child: GestureDetector(
                      onTap: aD.pickUpLL == null
                          ? () {
                              aD.toast("Set PickUp location first");
                              FlutterTts().speak("Set PickUp location first");
                            }
                          : null,
                      child: RaisedButton(
                        child: SizedBox(
                          child: Center(
                            child: Text(
                              aD.dropOffLL != null
                                  ? "Change Destination Location"
                                  : "Select Destination Location",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Color(
                                    aD.pickUpLL != null
                                        ? 0xff083E0C
                                        : 0xff1f0521,
                                  )),
                            ),
                          ),
                          height: 60,
                        ),
                        color: Color(0xffC9DFCB),
                        disabledColor: Color(0xffc9afcb),
                        shape: StadiumBorder(
                            side: BorderSide(
                                color: Color(aD.pickUpLL != null
                                    ? 0xff0F7016
                                    : 0xff1f0521))),
                        onPressed: aD.pickUpLL != null
                            ? () {
                                setState(() {
                                  aD.setPickup = false;
                                  Navigator.of(context)
                                      .pushNamed('setpickuplocation');
                                });
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Showcase(
                    key: aD.setCurrentAsDestination,
                    title: "Set Current Location as Destination",
                    description: "Say \"Set Current Location as Destination\"",
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: GestureDetector(
                        onTap: aD.pickUpLL == null
                            ? () {
                                aD.toast("Set PickUp location first.");
                                FlutterTts().speak("Set PickUp location first");
                              }
                            : null,
                        child: FloatingActionButton(
                          heroTag: "Destination",
                          backgroundColor: aD.pickUpLL != null
                              ? Color(0xffC9DFCB)
                              : Color(0xffc9afcb),
                          child: Icon(
                            Icons.my_location,
                            color: Color(
                              aD.pickUpLL != null ? 0xff083E0C : 0xff1f0521,
                            ),
                          ),
                          onPressed: aD.pickUpLL != null
                              ? () async {
                                  var loc = await Location().getLocation();
                                  setState(() {
                                    aD.dropOffLL =
                                        new LatLng(loc.latitude, loc.longitude);
                                  });
                                }
                              : null,
                        ),
                      ),
                    ),
                  ),
                  flex: 1,
                ),
              ],
            ),
          ),
          /*SizedBox(height: 50.0,),
          Opacity(
              opacity: aD.pickUpLL != null && aD.dropOffLL != null ? 1 : 0.4,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Opacity(
                      opacity: aD.rideType != null ?1:0.4,
                      child: SelectableCircle(
                        color: Color(0xffEDE4ED),
                        selectedColor: Color(0xff448f49),
                        selectedBorderColor: Color(0xff0f7016),
                        child: aD.rideType != null ? Icon(Icons.check) : null,
                        width: 50,
                        isSelected: aD.rideType != null,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: RaisedButton(
                      color: Color(0xffC9DFCB),
                      disabledColor: Color(0xff945F97),
                      disabledTextColor: Color(0xffDBC9DC),
                      shape: StadiumBorder(
                          side: BorderSide(
                              color: Color(
                                  aD.pickUpLL != null && aD.dropOffLL != null
                                      ? 0xff0F7016
                                      : 0xff1F0521))),
                      child: SizedBox(height: 60,
                        child: Center(
                          child: Text(
                            "Select Ride Type",
                            style: TextStyle(size: 18.0
                                color: Color(
                                    aD.pickUpLL != null && aD.dropOffLL != null
                                        ? 0xff083E0C
                                        : 0xffDBC9DC)),
                          ),
                        ),
                      ),
                      onPressed: aD.pickUpLL != null && aD.dropOffLL != null
                          ? () async {
                              var response = await http.get(
                                  'https://api.uber.com/v1.2/products?latitude=${aD.pickUpLL.latitude}&longitude=${aD.pickUpLL.longitude}');
                              print(response.body);
                            }
                          : null,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox()
                    ),]
                  ),),*/
          SizedBox(
            height: 50.0,
          ),
          Opacity(
            opacity: Root.of(context).pickUpLL != null &&
                    Root.of(context).dropOffLL != null &&
                    aD.rideType != null
                ? 1
                : 0.4,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 4,
                  child: Showcase(
                    key: aD.bookNewRide,
                    title: "Proceed to book your ride",
                    description: "Say \"Book My Ride\"",
                    child: SizedBox(
                      child: GestureDetector(
                        onTap: aD.pickUpLL == null && aD.dropOffLL == null
                            ? () {
                                aD.toast(
                                    "Set PickUp and Destination Location first");
                                FlutterTts().speak("Set PickUp and Destination location first");
                              }
                            : (aD.dropOffLL == null
                                ? () {
                                    aD.toast("Set Destination Location first");
                                    FlutterTts().speak("Set Destination location first");
                                  }
                                : null),
                        child: RaisedButton(
                          onPressed: aD.pickUpLL != null &&
                                  aD.dropOffLL != null &&
                                  aD.rideType != null
                              ? () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: Color(0xffE4EFE5),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0))),
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text("Add as Favourite?"),
                                              GestureDetector(
                                                child: Icon(
                                                  Icons.cancel,
                                                  color: Colors.red,
                                                  size: 36,
                                                ),
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          ),
                                          content: Text(
                                              "Add this ride as a favourite if you often need to travel between these two location."),
                                          actions: <Widget>[
                                            RaisedButton(
                                              highlightElevation: 0,
                                              highlightColor: Color(0xfffeeee7),
                                              focusColor: Color(0xfffeeee7),
                                              elevation: 0.0,
                                              onPressed: () async {
                                                //launch uber ride here
                                                Navigator.of(context).pop();
                                                launch(
                                                    "https://m.uber.com/ul/?client_id=CI51-MLco_RasO6JzweBuw2XCCkm4XDw&action=setPickup&pickup[latitude]=${aD.pickUpLL.latitude}&pickup[longitude]=${aD.pickUpLL.longitude}&dropoff[latitude]=${aD.dropOffLL.latitude}&dropoff[longitude]=${aD.dropOffLL.longitude}");
                                                var addressP = (await Geocoder
                                                        .local
                                                        .findAddressesFromCoordinates(
                                                            new Coordinates(
                                                                aD.pickUpLL
                                                                    .latitude,
                                                                aD.pickUpLL
                                                                    .longitude)))
                                                    .first;
                                                var addressD = (await Geocoder
                                                        .local
                                                        .findAddressesFromCoordinates(
                                                            new Coordinates(
                                                                aD.dropOffLL
                                                                    .latitude,
                                                                aD.dropOffLL
                                                                    .longitude)))
                                                    .first;
                                                var hR = new Ride(
                                                    pickUpAddress:
                                                        addressP.addressLine,
                                                    destinationAddress:
                                                        addressD.addressLine,
                                                    pickUpLat:
                                                        aD.pickUpLL.latitude,
                                                    pickUpLng:
                                                        aD.pickUpLL.longitude,
                                                    dropOffLat:
                                                        aD.dropOffLL.latitude,
                                                    dropOffLng:
                                                        aD.dropOffLL.longitude,
                                                    bookedOn: DateFormat(
                                                            "EEE d/MM/yyyy")
                                                        .format(
                                                            DateTime.now()));

                                                print(DateFormat(
                                                        "EEE d/MM/yyyy")
                                                    .format(DateTime
                                                        .now())); //TODO repair things here.No such table "History"
                                                db.addHistory(hR);
                                                setState(() {
                                                  aD.pickUpLL = null;
                                                  aD.dropOffLL = null;
                                                });
                                              },
                                              child: Text(
                                                "Don't Add",
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Color(0xff54230E),
                                                ),
                                              ),
                                              color: Colors.transparent,
                                            ),
                                            RaisedButton(
                                              onPressed: () async {
                                                //Save as favourite
                                                //launch uber ride here
                                                Navigator.of(context).pop();
                                                launch(
                                                    "https://m.uber.com/ul/?client_id=CI51-MLco_RasO6JzweBuw2XCCkm4XDw&action=setPickup&pickup[latitude]=${aD.pickUpLL.latitude}&pickup[longitude]=${aD.pickUpLL.longitude}&dropoff[latitude]=${aD.dropOffLL.latitude}&dropoff[longitude]=${aD.dropOffLL.longitude}");

                                                var fR = new FavRides();

                                                var address = (await Geocoder
                                                        .local
                                                        .findAddressesFromCoordinates(
                                                            new Coordinates(
                                                                aD.pickUpLL
                                                                    .latitude,
                                                                aD.pickUpLL
                                                                    .longitude)))
                                                    .first;
                                                fR.pickUpAdd =
                                                    address.addressLine;
                                                fR.pickUpLat =
                                                    aD.pickUpLL.latitude;
                                                fR.pickUpLng =
                                                    aD.pickUpLL.longitude;
                                                address = (await Geocoder.local
                                                        .findAddressesFromCoordinates(
                                                            new Coordinates(
                                                                aD.dropOffLL
                                                                    .latitude,
                                                                aD.dropOffLL
                                                                    .longitude)))
                                                    .first;
                                                fR.dropOffAdd =
                                                    address.addressLine;
                                                fR.dropOffLat =
                                                    aD.dropOffLL.latitude;
                                                fR.dropOffLng =
                                                    aD.dropOffLL.longitude;
                                                var hR = new Ride(
                                                    pickUpAddress: fR.pickUpAdd,
                                                    destinationAddress:
                                                        fR.dropOffAdd,
                                                    pickUpLat:
                                                        aD.pickUpLL.latitude,
                                                    pickUpLng:
                                                        aD.pickUpLL.longitude,
                                                    dropOffLat:
                                                        aD.dropOffLL.latitude,
                                                    dropOffLng:
                                                        aD.dropOffLL.longitude,
                                                    bookedOn: DateFormat(
                                                            "EEE d/MM/yyyy")
                                                        .format(
                                                            DateTime.now()));
                                                print(DateFormat(
                                                        "EEE d/MM/yyyy")
                                                    .format(DateTime
                                                        .now())); //TODO repair things here.No such table "History"
                                                db.addFav(fR);
                                                db.addHistory(hR);
                                                setState(() {
                                                  aD.pickUpLL = null;
                                                  aD.dropOffLL = null;
                                                });
                                              },
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.favorite_border,
                                                    color: Color(0xffE4EFE5),
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    "Yes, Add!",
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Color(0xffE4EFE5),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              color: Color(0xff5f9f63),
                                            ),
                                          ],
                                        );
                                      });
                                }
                              : null,
                          color: Color(0xffC9DFCB),
                          disabledColor: Color(0xffc9afcb),
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: Color(Root.of(context).pickUpLL != null &&
                                      Root.of(context).dropOffLL != null
                                  ? 0xff0F7016
                                  : 0xff1f0521),
                            ),
                          ),
                          child: SizedBox(
                              height: 100,
                              width: 150,
                              child: Center(
                                child: Text(
                                  "Book My Ride",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Color(aD.pickUpLL != null &&
                                              aD.dropOffLL != null &&
                                              aD.rideType != null
                                          ? 0xff083E0C
                                          : 0xff1f0521)),
                                ),
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(),
                  flex: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
