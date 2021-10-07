import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner =false;
  String email;
  String password;
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
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email',  hintStyle: TextStyle(color: Colors.white), fillColor: Color(0xff0275d8), filled: true), ////
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
              RoundedButton(title: 'Register', colour: Color(0xff03dac6), onPressed: () async { ////
                setState(() {
                  showSpinner = true;
                });
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);
                  if(newUser != null){
                    Navigator.pushNamed(context, ChatScreen.id);
                    return showDialog( ////
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text("Welcome to Vartalaap!", style: TextStyle(color: Colors.white),),
                        content: Text("You have successfully registered!", style: TextStyle(color: Colors.white),),
                        backgroundColor: Colors.black,
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Text("okay", style: TextStyle(color: Colors.white),),
                          ),
                        ],
                      ),
                    );
                  }
                  setState(() {
                    showSpinner = false;
                  });
                }
                catch(e) {
                  print(e);
                  return showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text("Already registered!", style: TextStyle(color: Colors.white),),
                      content: Text("The email you entered is already registered with vartalaap!", style: TextStyle(color: Colors.white),),
                      backgroundColor: Colors.black,
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Text("okay", style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    ),
                  );
                }
              },),
            ],
          ),
        ),
      ),
    );
  }
}
