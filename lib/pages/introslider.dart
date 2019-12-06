import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

class AppIntroSlider extends StatefulWidget {
  @override
  _AppIntroSliderState createState() => _AppIntroSliderState();
}

class _AppIntroSliderState extends State<AppIntroSlider> {
  List<Slide> slides = new List<Slide>();
  void addSlides() {
    slides.add(
      new Slide(
          backgroundColor: Color(0xffFEDDCF),
          styleDescription: TextStyle(
              color: Color(0xffC45120),
              fontWeight: FontWeight.w500,
              fontSize: 20),
          pathImage: "lib/assets/Entertainment.png",
          heightImage: 375,
          widgetTitle: SizedBox(
            height: 0,
            width: 0,
          ),
          description: "Easily search and watch videos from Youtube"),
    );
    slides.add(new Slide(
        backgroundColor: Color(0xffFEDDCF),
        styleDescription: TextStyle(
            color: Color(0xffC45120),
            fontWeight: FontWeight.w500,
            fontSize: 20),
        pathImage: "lib/assets/Book.png",
        heightImage: 375,
        widgetTitle: SizedBox(),
        description: "Book an Uber ride for all your transportation need"));
    slides.add(new Slide(
        backgroundColor: Color(0xffFEDDCF),
        styleDescription: TextStyle(
            color: Color(0xffC45120),
            fontWeight: FontWeight.w500,
            fontSize: 20),
        pathImage: "lib/assets/Speech.png",
        heightImage: 375,
        widgetTitle: SizedBox(),
        description:
            "Powerful Voice Integration to help you do things quickly"));
    slides.add(new Slide(
        backgroundColor: Color(0xffFEDDCF),
        styleDescription: TextStyle(
            color: Color(0xffC45120),
            fontWeight: FontWeight.w500,
            fontSize: 20),
        pathImage: "lib/assets/Help.png",
        heightImage: 375,
        widgetTitle: SizedBox(),
        description: "Help button to identify what to speak"));
  }

  @override
  void initState() {
    super.initState();
    addSlides();
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      slides: this.slides,
      colorSkipBtn: Color(0xff448F49),
      colorDoneBtn: Color(0xff448F49),
      colorPrevBtn: Color(0xff448F49),
      renderNextBtn: Container(
        height: 30,
        width: 150,
        child: Center(
          child: Text(
            "Next",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        decoration: BoxDecoration(
            color: Color(0xff448F49), borderRadius: BorderRadius.circular(25)),
      ),
      onDonePress: () {
        Navigator.of(context).popAndPushNamed('home');
      },
    );
  }
}
