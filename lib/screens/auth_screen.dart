import 'dart:io';
import '../widgets/auth/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  void _submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
    File? image,
  ) async {
    UserCredential authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final ref = FirebaseStorage.instance
            .ref()
            .child("user_image")
            .child("${authResult.user!.uid}.jpg");

        final metadata = SettableMetadata(
          contentType: 'image/jpg',
        );

        await ref.putFile(image!).whenComplete((() {}));

        final url = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection("users")
            .doc(authResult.user!.uid)
            .set({
          "username": username,
          "email": email,
          "image_url": url,
        });
      }
      setState(() {
        _isLoading = false;
      });
    } on FirebaseAuthException catch (err) {
      var message = "An error occured, please check your credentials";
      if (err.message != null) {
        message = err.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(err.message!),
        backgroundColor: Theme.of(context).errorColor,
      ));
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: AuthForm(submitFn: _submitAuthForm, isLoading: _isLoading));
  }
}
