import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email, password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 100.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                cursorColor: Colors.white, ////
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email', hintStyle: TextStyle(color: Colors.white), fillColor: Color(0xff0275d8), filled: true), ////
                style: TextStyle(color: Colors.white), ////
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password', hintStyle: TextStyle(color: Colors.white), fillColor: Color(0xff0275d8), filled: true), ////
                style: TextStyle(color: Colors.white), ////
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(title: 'Log In', colour: Color(0xff03dac6), onPressed: () async{ ////
                setState(() {
                  showSpinner = true;
                });
                try{
                final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
                if(user != null){
                  Navigator.pushNamed(context, ChatScreen.id);
                }
                setState(() {
                  showSpinner =false;
                });
                }
                catch(e){
                  print(e);
                }
              },),
            ],
          ),
        ),
      ),
    );
  }
}