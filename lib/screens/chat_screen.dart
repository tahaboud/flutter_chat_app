import 'package:chat_app/widgets/chat/messages.dart';
import 'package:chat_app/widgets/chat/new_message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();
    FirebaseMessaging.onMessage.listen((event) {
      print(1);
      print(event.toMap());
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print(2);
      print(event.toMap());
    });
    fbm.getInitialMessage().then((value) {
      if (value == null) {
        print(3);
        print(value);
      } else {
        print(3);
        print(value.toMap());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Flutter Chat"),
        actions: [
          DropdownButton(
            items: [
              DropdownMenuItem(
                  value: "logout",
                  child: Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.exit_to_app,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text("Logout")
                      ],
                    ),
                  ))
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == "logout") {
                FirebaseAuth.instance.signOut();
              }
            },
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (futureContext, futureSnapshot) => Container(
                child: Column(
                  children: [
                    Expanded(
                      child: Messages(),
                    ),
                    NewMessage(),
                  ],
                ),
              )),
    );
  }
}
