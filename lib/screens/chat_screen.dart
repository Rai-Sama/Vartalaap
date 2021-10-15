import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:function_tree/function_tree.dart';

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
                        if(messageText == "/git"){
                          _firestore.collection('messages').add({
                            'text':"You can find Vartalaap on github.com/rai-sama/vartalaap",
                            'sender': "test@gmail.com",
                          });
                        }
                        if(messageText == "/why"){
                          _firestore.collection('messages').add({
                            'text':"This app was created as a practical project for Mobile Computing and Communication Lab course",
                            'sender': "test@gmail.com",
                          });
                        }
                      
                        if(messageText[0] == "!"){
                          var res = messageText.substring(1);
                          _firestore.collection('messages').add({
                            'text':(res.interpret()).toString(),
                            'sender': "test@gmail.com",
                          });
                        }
                        if(messageText == "Nice"){
                          var res = messageText.substring(1);
                          _firestore.collection('messages').add({
                            'text':"Nice",
                            'sender': "nice@gmail.com",
                          });
                        }
                        if(messageText == "pi"){
                          var res = messageText.substring(1);
                          _firestore.collection('messages').add({
                            'text':"3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679821480865132823066470938446095505822317253594081284811174502841027019385211055596446229489549303819644288109756659334461284756482337867831652712019091456485669234603486104543266482133936072602491412737245870066063155881748815209209628292540917153643678925903600113305305488204665213841469519415116094330572703657595919530921861173819326117931051185480744623799627495673518857527248912279381830119491298336733624406566430860213949463952247371907021798609437027705392171762931767523846748184676694051320005681271452635608277857713427577896091736371787214684409012249534301465495853710507922796892589235420199561121290219608640344181598136297747713099605187072113499999983729780499510597317328160963185950244594553469083026425223082533446850352619311881710100031378387528865875332083814206171776691473035982534904287554687311595628638823537875937519577818577805321712268066130019278766111959092164201989",
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
