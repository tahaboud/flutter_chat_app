import 'package:chat_app/screens/splash_screen.dart';

import './screens/chat_screen.dart';
import './screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
          primarySwatch: Colors.pink,
          backgroundColor: Colors.pink,
          colorScheme: ThemeData().colorScheme.copyWith(
                secondary: Colors.deepPurple,
              ),
          buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: Colors.pink,
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          )),
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: ((context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : StreamBuilder(
                    builder: ((userContext, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) return SplashScreen();
                      if (userSnapshot.hasData) {
                        return ChatScreen();
                      }
                      return AuthScreen();
                    }),
                    stream: FirebaseAuth.instance.authStateChanges(),
                  )),
      ),
    );
  }
}
