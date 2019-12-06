import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:urcab/main.dart';
import 'package:google_maps_webservice/places.dart' as places;
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:showcaseview/showcaseview.dart';

class SetPickUpLocation extends StatefulWidget {
  String searchKey;
  SetPickUpLocation({this.searchKey});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SetPickUpLocationState();
  }
}

class SetPickUpLocationState extends State<SetPickUpLocation> {
  static const String apiKey = "AIzaSyDTSNPxWWXuGqI1vBR-v-slXAdCB5tRgQE";
  LatLng selectedLocation;
  GoogleMapController _controller;
  final place = new places.GoogleMapsPlaces(
      apiKey: "AIzaSyDTSNPxWWXuGqI1vBR-v-slXAdCB5tRgQE");
  Set<Marker> markers = new Set<Marker>();
  List<ListTile> searchResults = [];
  bool showList = false;
  bool startSearching = false;
  bool initialSearching = false;
  LatLng currentLocation;

  void setPickupMarker(LatLng loc) {
    setState(() {
      selectedLocation = loc;
      markers.add(
        new Marker(
          markerId: MarkerId("pickUp"),
          position: loc,
        ),
      );
    });
  }

  Future<LatLng> setCurrentLocation() async {
    var loc = await Location().getLocation();
    currentLocation = new LatLng(loc.latitude, loc.longitude);
    return currentLocation;
  }

  Future<List<ListTile>> initialSearch(String search) async {
    //startSearching = true;
    initialSearching = false;
    searchResults = [];
    places.PlacesSearchResponse response = await place.searchByText(search);
    if (response.isOkay) {
      showList = true;
      response.results.forEach((places.PlacesSearchResult res) {
        searchResults.add(new ListTile(
          onTap: () {
            showList = false;
            setPickupMarker(new LatLng(
                res.geometry.location.lat, res.geometry.location.lng));
            _controller.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  zoom: 16.0,
                  target: selectedLocation,
                ),
              ),
            );
          },
          title: Text(res.name),
          subtitle: Text(res
              .formattedAddress), //TODO add res.icon using image.network and using in Row
        ));
      });
    } else {
      print(response.errorMessage);
    }
    showList = searchResults.isNotEmpty;
    startSearching = false;
    return searchResults;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCurrentLocation();
    if (widget.searchKey != null && widget.searchKey.length > 0) {
      initialSearching = true;
      //startSearching = true;
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (Root.of(context).setPickup && Root.of(context).pickUpLL != null) {
      selectedLocation = Root.of(context).pickUpLL;
      markers.add(
        new Marker(
          markerId: MarkerId("pickUp"),
          position: Root.of(context).pickUpLL,
        ),
      );
    } else if (!Root.of(context).setPickup &&
        Root.of(context).dropOffLL != null) {
      selectedLocation = Root.of(context).dropOffLL;
      markers.add(
        new Marker(
          markerId: MarkerId("pickUp"),
          position: Root.of(context).dropOffLL,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var aD = Root.of(context);
    // TODO: implement build
    return ShowCaseWidget(
      builder: Builder(
        builder: (context) {
          return SafeArea(
              child: FocusWatcher(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              floatingActionButton: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Showcase(
                    key: aD.mapCurrentLocationKey,
                    title: aD.setPickup
                        ? "Set current location as Pick Up"
                        : "Set current location as Drop Off",
                    description: "Say \"Select current location\"",
                    child: FloatingActionButton(
                      heroTag: "Current Location",
                      backgroundColor: Color(0xffE4EFE5),
                      child: Icon(
                        Icons.my_location,
                        color: Color(0xff0A4A0E),
                      ),
                      onPressed: () async {
                        setCurrentLocation();
                        setState(() {});
                        Location loc = new Location();
                        if (await loc.hasPermission()) {
                          setPickupMarker(currentLocation);
                          _controller.animateCamera(
                              CameraUpdate.newCameraPosition(CameraPosition(
                                  zoom: 16.0, target: currentLocation)));
                          selectedLocation = currentLocation;
                        } else {
                          await loc.requestPermission();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  selectedLocation != null
                      ? FloatingActionButton.extended(
                          heroTag: "Confirm",
                          tooltip: "Confirm Pickup Point",
                          label: Center(
                            child: Text(
                              "CONFIRM",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          icon: Icon(Icons.check),
                          backgroundColor: Color(0xff0F7016),
                          foregroundColor: Color(0xffE4EFE5),
                          onPressed: () {
                            setState(() {
                              if (aD.setPickup)
                                aD.pickUpLL = selectedLocation;
                              else
                                aD.dropOffLL = selectedLocation;
                              Navigator.of(context).pop();
                            });
                          },
                        )
                      : SizedBox(),
                ],
              ),
              body: Container(
                child: Stack(
                  children: <Widget>[
                    FutureBuilder(
                      future: setCurrentLocation(),
                      builder: (c, sn) {
                        if (sn.hasData) {
                          return GoogleMap(
                            onMapCreated: (c) {
                              _controller = c;
                            },
                            markers: markers,
                            initialCameraPosition: CameraPosition(
                              target: selectedLocation != null
                                  ? selectedLocation
                                  : sn.data,
                              zoom: 16.0,
                            ),
                            onTap: (loc) {
                              setState(() {
                                showList = false;
                                selectedLocation = loc;
                              });
                              setPickupMarker(loc);
                            },
                          );
                        } else
                          return Center(
                              child: CircularProgressIndicator(
                            backgroundColor: Color(0xffDBC9DC),
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xff702A74)),
                          ));
                      },
                    ),
                    Container(
                        margin: EdgeInsets.all(16.0),
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Showcase(
                              key: aD.mapSearchBar,
                              title: "Search for Pick Up location",
                              description:
                                  "Say \"Search for {your search query here}\"",
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: TextFormField(
                                      onTap: () {
                                        setState(() {
                                          /*showList =    //TODO bug here. on first tap we don't need to open the list
                                              true;*/ //TODO open the list again when text field is tapped
                                        });
                                      },
                                      initialValue: widget.searchKey != null
                                          ? widget.searchKey
                                          : "",
                                      keyboardType: TextInputType.text,
                                      onChanged: (search) async {
                                        if (search.length >= 5) {
                                          startSearching = true;
                                          setState(() {});
                                          searchResults = [];
                                          places.PlacesSearchResponse response =
                                              await place.searchByText(search);
                                          if (response.isOkay) {
                                            response.results.forEach(
                                                (places.PlacesSearchResult
                                                    res) {
                                              searchResults.add(new ListTile(
                                                onTap: () {
                                                  showList = false;
                                                  setPickupMarker(new LatLng(
                                                      res.geometry.location.lat,
                                                      res.geometry.location
                                                          .lng));
                                                  _controller.animateCamera(
                                                    CameraUpdate
                                                        .newCameraPosition(
                                                      CameraPosition(
                                                        zoom: 16.0,
                                                        target:
                                                            selectedLocation,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                title: Text(res.name),
                                                subtitle: Text(res
                                                    .formattedAddress), //TODO add res.icon using image.network and using in Row
                                              ));
                                            });
                                          } else
                                            print(response.errorMessage);
                                          showList = searchResults.isNotEmpty;
                                          startSearching = false;
                                          setState(() {});
                                        }
                                      },
                                      decoration: InputDecoration(
                                        focusColor: Color(0xff063109),
                                        fillColor: Color(0xffC9DFCB),
                                        hoverColor: Color(0xffC9DFCB),
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: Color(0xff297F2F),
                                          size: 24.0,
                                        ),
                                        hintText: aD.setPickup
                                            ? "Search Pick Up Location..."
                                            : "Search Drop Off Location...",
                                        contentPadding:
                                            EdgeInsets.fromLTRB(4, 12, 4, 0),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                      icon: Icon(
                                        Icons.help,
                                        color: Color(0xff297F2F),
                                        size: 40.0,
                                      ),
                                      onPressed: () {
                                        ShowCaseWidget.of(context)
                                            .startShowCase([
                                          aD.mapSearchBar,
                                          aD.mapCurrentLocationKey
                                        ]);
                                      })
                                  //TODO add voice button
                                ],
                              ),
                            ),
                            startSearching
                                ? Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: CircularProgressIndicator(
                                          backgroundColor: Color(0xffDBC9DC),
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Color(0xff702A74)),
                                        )),
                                  )
                                : SizedBox(
                                    height: 8,
                                  ),
                            showList
                                ? Container(
                                    height:
                                        MediaQuery.of(context).size.height / 2 -
                                            50,
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: searchResults,
                                    ),
                                  )
                                : SizedBox(),
                            initialSearching
                                ? FutureBuilder(
                                    future: initialSearch(widget.searchKey),
                                    builder: (context, sp) {
                                      if (sp.hasData) {
                                        startSearching = false;
                                        return Container(
                                          height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  2 -
                                              50,
                                          child: ListView(
                                            shrinkWrap: true,
                                            children: searchResults,
                                          ),
                                        );
                                      } else {
                                        return SizedBox();
                                      }
                                    },
                                  )
                                : SizedBox()
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ));
        },
      ),
    );
  }
}
