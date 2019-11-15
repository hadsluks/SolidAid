//TODO all the utility widget throughout the app should be implemented here
//TODO rating box widget
//TODO appCard widget
//TODO expandable card for ride details in book call to action
//TODO ride count badge
//TODO exit app prompt dialog
//TODO ride Confirmation box that allows a ride to be favourite
//and others
import 'package:flutter/material.dart';

/*
class RatingBox extends StatelessWidget {
  RatingBox({this.rating,this.maxRating});

  final double rating;
  final double maxRating;
  Color _backgroundColor;
  Color _borderColor;
  Color _textColor;

  @override
  Widget build(BuildContext context) {
    double _fraction = rating/maxRating;
    if(_fraction >= 0.6) {
      _backgroundColor = Colors.green[200];
      _textColor = Colors.green[900];
      _borderColor = Colors.green[400];
    } else if (_fraction >= 0.3) {
      _backgroundColor = Colors.yellow[200];
      _textColor = Colors.yellow[900];
      _borderColor = Colors.yellow[400];
    } else {
      _backgroundColor = Colors.red[200];
      _textColor = Colors.red[900];
      _borderColor = Colors.red[400];
    }

    return Container(
      decoration: BoxDecoration(color: _backgroundColor,border: Border.all(color: _borderColor),borderRadius: BorderRadius.all(Radius.circular(15.0))),
      padding: EdgeInsets.all(5.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.star,size: 10.0,color: _textColor,),
          SizedBox(
            width: 2.0,
          ),
          RichText(
            text: TextSpan(
              style: TextStyle(color: _textColor,fontSize: 10.0),
              children: <TextSpan> [
                TextSpan(text: this.rating.toString(),style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: '\/'),
                TextSpan(text: this.maxRating.toString()),
              ]
            ),
          )
        ],
      ),
    );
  }
}
*/
