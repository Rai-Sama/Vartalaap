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
                            'text':"3.1415926535 8979323846 2643383279 5028841971 6939937510 5820974944 5923078164 0628620899 8628034825 3421170679 8214808651 3282306647 0938446095 5058223172 5359408128 4811174502 8410270193 8521105559 6446229489 5493038196 4428810975 6659334461 2847564823 3786783165 2712019091 4564856692 3460348610 4543266482 1339360726 0249141273 7245870066 0631558817 4881520920 9628292540 9171536436 7892590360 0113305305 4882046652 1384146951 9415116094 3305727036 5759591953 0921861173 8193261179 3105118548 0744623799 6274956735 1885752724 8912279381 8301194912 9833673362 4406566430 8602139494 6395224737 1907021798 6094370277 0539217176 2931767523 8467481846 7669405132 0005681271 4526356082 7785771342 7577896091 7363717872 1468440901 2249534301 4654958537 1050792279 6892589235 4201995611 2129021960 8640344181 5981362977 4771309960 5187072113 4999999837 2978049951 0597317328 1609631859 5024459455 3469083026 4252230825 3344685035 2619311881 7101000313 7838752886 5875332083 8142061717 7669147303 5982534904 2875546873 1159562863 8823537875 9375195778 1857780532 1712268066 1300192787 6611195909 2164201989...",
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
