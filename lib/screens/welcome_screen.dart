import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/screens/weather_screen.dart';
class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {

  AnimationController controller;
  Animation animation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
      //upperBound: 100.0,
    );
    animation = ColorTween(begin:Colors.black26, end: Colors.black).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }
  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: [
                Hero(
                  tag: 'logo',
                  child:
                    Container(
                      child: Image.asset('images/logo.png'),
                      height: 35.0,
                    ),
    ),
                    // TyperAnimatedTextKit(
                    //   text: ['Vartalaap '],
                    //   textStyle: TextStyle(
                    //     fontSize: 45.0,
                    //     fontWeight: FontWeight.w900,
                    //   ),
                    // ),
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 45,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    shadows: [
                      Shadow(
                        blurRadius: 7.0,
                        color: Colors.white,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: AnimatedTextKit(
                    repeatForever: true,
                    animatedTexts: [
                      FlickerAnimatedText(' Vartalaap'),
                      FlickerAnimatedText(' वार्तालाप'),

                    ],

                  ),
                ),


              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(title: 'Log In', colour: Color(0xff0275d8), onPressed: () { ////
              Navigator.pushNamed(context, LoginScreen.id);
            },),
            RoundedButton(title: 'Register', colour: Color(0xff0275d8), onPressed: () { ////
              Navigator.pushNamed(context, RegistrationScreen.id);
            },),
            RoundedButton(title: 'Weather', colour: Color(0xff0275d8), onPressed: () { ////
              Navigator.pushNamed(context, WeatherApp.id);
            },),
          ],
        ),
      ),
    );
  }
}


