import 'dart:async';
import 'package:byebye_flutter_app/app/bottom_navigation_bar_controller.dart';
import 'package:byebye_flutter_app/chat/all_users_screen.dart';
import 'package:byebye_flutter_app/chat/models/user_details.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({Key key}) : super(key: key);

  @override
  _ChatHomePageState createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  DocumentReference _documentReference;
  final UserDetails _userDetails = UserDetails();
  var mapData = <String, String>{};
  // var mapData = Map<String, String>();
  String uid;

  // TODO(marius): Third Party Login Removed due to restriction from App Store.
  Future<FirebaseUser> signIn() async {
    final GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;

    final AuthCredential authCredential = GoogleAuthProvider.getCredential(
        idToken: _signInAuthentication.idToken,
        accessToken: _signInAuthentication.accessToken);

    final FirebaseUser user =
        (await _firebaseAuth.signInWithCredential(authCredential)).user;
    print('signed in ' + user.displayName);
    return user;
  }

  void addDataToDb(FirebaseUser user) {
    _userDetails.name = user.displayName;
    _userDetails.emailId = user.email;
    _userDetails.photoUrl = user.photoUrl;
    _userDetails.uid = user.uid;
    mapData = _userDetails.toMap(_userDetails);

    uid = user.uid;

    _documentReference = Firestore.instance.collection('users').document(uid);

    _documentReference.get().then((documentSnapshot) {
      if (documentSnapshot.exists) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AllUsersScreen(),
          ),
        );
      } else {
        _documentReference.setData(mapData).whenComplete(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AllUsersScreen(),
            ),
          );
        }).catchError((e) {
          print('Error adding collection to Database $e');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: myOnPrimaryColor),
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => BottomNavigationBarController()),
              (Route<dynamic> route) => false),
        ),
        title: Text(
          'CHAT',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        titleSpacing: 0.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              ':-) Hi!',
              style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
            ),
            MaterialButton(
              elevation: 2.0,
              padding: EdgeInsets.all(8.0),
              textColor: myOnSecondaryColor,
              color: mySecondaryColor,
              child: Text('TRY THE BYEBYE CHAT (BETA)'),
              splashColor: myBackgroundColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllUsersScreen(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
