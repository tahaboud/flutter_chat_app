import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  var _enteredMessage = "";

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    FirebaseFirestore.instance.collection("chat").add({
      "text": _enteredMessage,
      "createdAt": Timestamp.now(),
      "userId": user.uid,
      "username": userData["username"],
      "userImage": userData["image_url"]
    });
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken(
        vapidKey:
            "BLS8qaKOut_ifDQbYJ7ckFRHKlmvzzbqJWzb-9OcDa3o2CmMV5ueuhDnoiaqgyNBCfLvB7VRTLNf1fTQWMZBs_I");
    messaging.subscribeToTopic("chat");
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(label: Text("Send a message ...")),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(Icons.send),
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
