import 'package:clarityhub/domains/app/pages/dashboard.dart';
import 'package:clarityhub/preferences.dart';
import 'package:clarityhub/theme.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "Welcome",
        description: "Welcome to Clarity Hub Mobile!\n\nYou can record customer interviews and capture insightful moments with your camera.",
        // pathImage: "images/photo_eraser.png",
        backgroundColor: MyTheme.primary,
      ),
    );
    slides.add(
      new Slide(
        title: "Record",
        description: "Create a notebook and then click the microphone button to start recording.",
        pathImage: "assets/images/record.png",
        backgroundColor: Colors.blue,
      ),
    );
    slides.add(
      new Slide(
        title: "Capture Photos",
        description:
        "Use your camera to capture photos and add them to your notebooks.",
        pathImage: "assets/images/photos.png",
        backgroundColor: Colors.green,
      ),
    );
    slides.add(
      new Slide(
        title: "Get Started!",
        description:
        "Start capturing your valuable customer conversations!",
        pathImage: "assets/images/start.png",
        backgroundColor: MyTheme.primary,
      ),
    );
  }

  void onDonePress() async {
    await Preferences.setOnboarded();

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => new Dashboard()));
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
      colorDot: Color(0xFFFFFFFF),
      colorActiveDot: Color(0xFFFFFFFF),
      typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION
    );
  }
}