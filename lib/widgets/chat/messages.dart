import 'dart:developer';

import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder<QuerySnapshot>(
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        return ListView.builder(
            reverse: true,
            itemBuilder: ((context, index) {
              return MessageBubble(
                userId: chatSnapshot.data!.docs[index]["userId"],
                username: chatSnapshot.data!.docs[index]["username"],
                message: chatSnapshot.data!.docs[index]["text"],
                image: chatSnapshot.data!.docs[index]["userImage"],
                isMe: chatSnapshot.data!.docs[index]["userId"] == userId,
                key: ValueKey(chatSnapshot.data!.docs[index].id),
              );
            }),
            itemCount: chatSnapshot.data!.docs.length);
      },
      stream: FirebaseFirestore.instance
          .collection("chat")
          .orderBy(
            "createdAt",
            descending: true,
          )
          .snapshots(),
    );
  }
}
