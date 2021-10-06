import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;
class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String messageText;
  @override
  void initState(){
    super.initState();
    getCurrentUser();
  }
  void getCurrentUser() async {
    try{
    final user = await _auth.currentUser();
    if(user != null){
      loggedInUser = user;
    }}
    catch(e){
      print(e);
    }

  }
  // void getMessages() async{
  //   final messages = await _firestore.collection('messages').getDocuments();
  //   for(var message in messages.documents){
  //     print(message.data);
  //   }
  // }

  //}
  void messagesStream() async {
    await for(var snapshot in _firestore.collection('messages').snapshots()){
      for(var message in snapshot.documents){
        print(message.data);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                messagesStream();
                _auth.signOut();
                Navigator.pop(context);
                Navigator.pop(context);

              }),
        ],
        title: Text('Vartalaap', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),), ////
        backgroundColor: Colors.black,
        //backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                        decoration: kMessageTextFieldDecoration.copyWith(hintText: "Enter your message here...", hintStyle: TextStyle(color: Colors.white), fillColor: Colors.black, filled: true),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                        messageTextController.clear();
                        _firestore.collection('messages').add({
                          'text':messageText,
                          'sender': loggedInUser.email,
                        });
                        if(messageText == "/help"){
                          _firestore.collection('messages').add({
                            'text':"This is Vartalaap, a chatting app for you and your friends to stay connected!",
                            'sender': "test@gmail.com",
                          });
                        }

                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black, ////
    );
  }
}

class MessagesStream extends StatelessWidget {
  // const MessagesStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot){
        List<MessageBubble> messageBubbles = [];
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.deepPurple,
            ),

          );
        }
        var messages = snapshot.data.documents;
        var cnt = 0;
        var temp = [];
        for(var message in messages){
          var txt = message.data['text'];
          var sndr = message.data['sender'];
          temp.add([txt, sndr]);


        }

        var temp1 = temp.reversed.toList();
        for(var message in temp1){
           print(message[0]);

        }

        // var messages = snapshot.data.documents.reversed;



        for(var message in temp1){

          final messageText = message[0];//message.data['text'];
          final messageSender = message[1];//message.data['sender'];
          final currentUser = loggedInUser.email;

          // if(messageText == "/help"){
          //   temp.insert(cnt+1, ["Kya sahaayta kar sakta hu me aapki?", "Bot"]);
          // }

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
          );
          messageBubbles.add(messageBubble);

        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );


        return Column(
          children: messageBubbles,
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({this.sender, this.text, this.isMe});
  final String sender;
  final String text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender, style: TextStyle(
            fontSize: 12.0,
            color: Colors.white,
          ),),
          Material(
            borderRadius: isMe ? BorderRadius.only(topLeft: Radius.circular(30.0), bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0)) : BorderRadius.only(bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0), topRight: Radius.circular(30.0)),
            elevation: 5.0,
            color: isMe ? Color(0xff0275d8) : Color(0xff6200ee),
            child: Padding(
              padding:EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                  '$text',
                   style: TextStyle(
                     fontSize: 15.0,
                     fontWeight: FontWeight.bold, ////
                     color: Colors.white, ////
                   ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
