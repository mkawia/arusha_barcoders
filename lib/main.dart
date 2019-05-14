import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intro_slider/intro_slider.dart';
import 'package:arusha_barcoders/home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: IntroScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class IntroScreen extends StatefulWidget {
  IntroScreen({Key key}) : super(key: key);

  @override
  IntroScreenState createState() => new IntroScreenState();
}

// Custom config
class IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();
    slides.add(
      new Slide(
        title: "Arusha Barcoders",
        styleTitle: TextStyle(
            color: Colors.black,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description: "Barcode reading demo app made by arusha coders",
        styleDescription: TextStyle(
            color: Colors.black, fontSize: 20.0, fontFamily: 'RobotoMono'),
        pathImage: "images/barcode.png",
        backgroundColor: Colors.white,
        colorBegin: Colors.black,
        colorEnd: Colors.black,
        directionColorBegin: Alignment.topRight,
        directionColorEnd: Alignment.bottomLeft,
      ),
    );
    slides.add(
      new Slide(
        title: "Runs on android",
        styleTitle: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description: "",
        styleDescription: TextStyle(
            color: Colors.white, fontSize: 20.0, fontFamily: 'RobotoMono'),
        pathImage: "images/android.jpg",
        backgroundColor: Colors.black,
        colorBegin: Colors.white,
        colorEnd: Colors.white,
      ),
    );

    slides.add(
      new Slide(
        title: "Made with Flutter",
        styleTitle: TextStyle(
            color: Colors.black,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description:
            "The UI toolkit for building beautiful mobile apps on many platforms from a single codebase",
        styleDescription: TextStyle(
            color: Colors.black, fontSize: 20.0, fontFamily: 'RobotoMono'),
        pathImage: "images/flutter.png",
        backgroundColor: Colors.white,
        colorBegin: Colors.black,
        colorEnd: Colors.black,
        directionColorBegin: Alignment.topRight,
        directionColorEnd: Alignment.bottomLeft,
      ),
    );

    slides.add(
      new Slide(
        title: "So it runs on",
        styleTitle: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description: "",
        styleDescription: TextStyle(
            color: Colors.white, fontSize: 20.0, fontFamily: 'RobotoMono'),
        pathImage: "images/ios.png",
        backgroundColor: Colors.black,
        colorBegin: Colors.white,
        colorEnd: Colors.white,
        directionColorBegin: Alignment.topRight,
        directionColorEnd: Alignment.bottomLeft,
      ),
    );
  }

  void onDonePress() {
    //going home
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: Color(0xff01579F),
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: Color(0xff01579F),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      // List slides
      slides: this.slides,
      isShowPrevBtn: false,
      isShowSkipBtn: false,
      nameNextBtn: "",

      renderNextBtn: this.renderNextBtn(),

      // Done button
      renderDoneBtn: this.renderDoneBtn(),
      onDonePress: this.onDonePress,
      colorDoneBtn: Color(0x33000000),

      // Dot indicator
      colorDot: Color(0xff54C5F8),
      colorActiveDot: Color(0xff01579F),
      sizeDot: 13.0,

      // Show or hide status bar
      shouldHideStatusBar: true,
    );
  }
}
