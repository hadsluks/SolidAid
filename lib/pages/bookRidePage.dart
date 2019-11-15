import 'package:flutter/material.dart';
import 'package:urcab/pages/newRidePage.dart';
import 'package:urcab/pages/favRidesPage.dart';
import 'package:urcab/main.dart';
import 'package:urcab/pages/utilityWidget.dart';
import 'package:showcaseview/showcaseview.dart';

class BookRide extends StatefulWidget {
  @override
  _BookRideState createState() => _BookRideState();
}

class _BookRideState extends State<BookRide> with TickerProviderStateMixin {
  TabController _controller;

  @override
  Widget build(BuildContext context) {
    var aD = Root.of(context);
    _controller = TabController(length: 2, vsync: this, initialIndex: 1);
    Root.of(context).bookRideController = _controller;
    _controller.index = 1;
    return ShowCaseWidget(
      builder: Builder(builder: (context) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text("UrCab"),
              centerTitle: true,
              actions: <Widget>[
                SizedBox(
                  height: 30.0,
                  child: IconButton(
                      icon: Icon(Icons.help_outline),
                      onPressed: () {
                      }),
                )
              ],
              /*bottom: TabBar(
                controller: _controller,
                tabs: <Widget>[
                  Showcase(
                    key: aD.favTab,
                    title: "Favourite Rides",
                    description: "Say \"Show Favourite rides\"",
                    child: Tab(
                      icon: Icon(Icons.favorite),
                      text: "Favourite",
                    ),
                  ),
                  Showcase(
                    key: aD.newTab,
                    title: "New Ride",
                    description: "Say \"Show New Ride Page\"",
                    child: Tab(
                      icon: Icon(Icons.add_circle),
                      text: "New Ride",
                    ),
                  ),
                ],
              ),*/
            ),
            body: TabBarView(
              controller: _controller,
              children: <Widget>[
                FavRidePage(),
                NewRide(),
              ],
            ),
          ),
        );
      }),
    );
  }
}
