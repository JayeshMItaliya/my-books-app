import 'package:byebye_flutter_app/chat//all_users_screen.dart';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
//import 'package:google_sign_in/google_sign_in.dart';

class MyChat extends StatefulWidget {
  const MyChat({Key key}) : super(key: key);

  @override
  MyChatState createState() {
    return MyChatState();
  }
}

class MyChatState extends State<MyChat> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//  GoogleSignIn googleSignIn = GoogleSignIn();
  bool isLoggedIn = false;

//  void isSignedIn() async {
//    if (await googleSignIn.isSignedIn()) {
//      setState(() {
//        isLoggedIn = true;
//      });
//    } else {
//      setState(() {
//        isLoggedIn = false;
//      });
//    }
//  }

  @override
  void initState() {
    super.initState();
//    isSignedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
/*      appBar: AppBar(
        title: Text('chat'),
      ),*/
      /*title: "Chat App",
      theme: ThemeData(primarySwatch: Colors.red),
      routes: <String, WidgetBuilder>{
        '/chatscreen': (BuildContext context) => new AllUsersScreen(),
      },*/
      body: Container(
        child:
//        isLoggedIn == true
//            ? AllUsersScreen()
//            :
          AllUsersScreen(), //second option was ChatHomePage()
      ),
    );
  }
}
