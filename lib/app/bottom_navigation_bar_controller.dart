import 'dart:async';
import 'dart:convert';
import 'package:byebye_flutter_app/bloc/login_bloc.dart';
import 'package:byebye_flutter_app/booklovers/people_list.dart';
import 'package:byebye_flutter_app/constants/strings.dart';
import 'package:byebye_flutter_app/chat/all_users_screen.dart';
import 'package:byebye_flutter_app/library/category_list.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:byebye_flutter_app/notification_inbox/device_token.dart';
import 'package:byebye_flutter_app/notification_inbox/inbox.dart';
import 'package:byebye_flutter_app/stats/stats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:flutter/services.dart';
import '../my_constants/design_system.dart';
import 'home_page.dart';

class BottomNavigationBarController extends StatefulWidget {
  const BottomNavigationBarController({this.userUid, this.routeType});

  final String userUid;
  final dynamic routeType;

  @override
  _BottomNavigationBarControllerState createState() =>
      _BottomNavigationBarControllerState(userUid, routeType);
}

class _BottomNavigationBarControllerState
    extends State<BottomNavigationBarController> with WidgetsBindingObserver {
  _BottomNavigationBarControllerState(this.userUid, this.routeType);

  static const platform = MethodChannel('io.byebye.inventory/platform_channel');
  String intentData = 'false';

  final Firestore _firestore = Firestore.instance;
  final String userUid;
  final dynamic routeType;
  dynamic openChatList;
  bool isGet = false;
  bool isBadge = false;
  Timer timer;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    getIntent();
    getUserProfile(userUid).then((value) async {
      await deviceToken.generateToken();
      platform.setMethodCallHandler(_handleMethod);
    });

    ///This functionality commented because we don't require we change it to simple text note.
//    if (routeType != NavigateFrom.stats &&
//        routeType != NavigateFrom.library &&
//        routeType != NavigateFrom.bookLover &&
//        routeType != NavigateFrom.chat) {
//      createDemo();
//    }
    checkLoginStream();
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) async {
      openChatList = [];
      isBadge = false;
      final Query query = Firestore.instance
          .collection('chatList2')
          .document(prefsObject.getString('uid'))
          .collection(prefsObject.getString('uid'));
      final QuerySnapshot querySnapshot = await query.getDocuments();
      openChatList = querySnapshot.documents;
      for (dynamic badge in openChatList) {
        if (badge.data['badge'] != '' && badge.data['badge'] != '0') {
          isBadge = true;
        }
      }
      isGet = true;
      if (mounted) {
        setState(() {});
      }
    });
    Firestore.instance
        .collection('users')
        .document(prefsObject.getString('uid'))
        .updateData({'activeTime': DateTime.now()});
  }

  /// Called when Application is in foreground or background and you user tap on notification.
  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'notification':
        if (call.arguments != null) {
          final jsonResponse = json.decode(call.arguments);
          final payloadStr = jsonResponse['payload'];
          final payload = jsonDecode(payloadStr);
          if (payload['type'] == 'Admin') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationInbox(),
              ),
            );
          }
        }
    }
  }

  Future getIntent() async {
    var getData = await platform.invokeMethod('getIntent');
    if (getData == '{}') {
      getData = null;
    } else {
      getData = getData;
    }
    if (getData != null) {
      intentData = getData;
      if (intentData != 'false') {
        final jsonResponse = json.decode(intentData);
        final payloadStr = jsonResponse['payload'];
        final payload = jsonDecode(payloadStr);
        if (payload['type'] == 'Admin') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationInbox(),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(this);
    super.dispose();
    timer.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        changeStatus(); // print("Paused");
        break;
      case AppLifecycleState.resumed:
        changeStatus(); // print("Resumed");
        break;
      case AppLifecycleState.detached:
        changeStatus(); // print("Suspending");
        break;
    }
  }

  dynamic changeStatus() {
    Firestore.instance
        .collection('users')
        .document(prefsObject.getString('uid'))
        .updateData({'activeTime': DateTime.now()});
  }

  Future getUserProfile(String uid) async {
    final Query userInfo =
        _firestore.collection('users').where('uid', isEqualTo: uid);
    final QuerySnapshot querySnapshot = await userInfo.getDocuments();
    if (querySnapshot.documents.isNotEmpty) {
      prefsObject.setString(
          'emailId', querySnapshot.documents[0].data['emailId']);
      prefsObject.setString('name', querySnapshot.documents[0].data['name']);
      prefsObject.setString(
          'photoUrl', querySnapshot.documents[0].data['photoUrl']);
      prefsObject.setString('uid', querySnapshot.documents[0].data['uid']);
      prefsObject.setString(
          'userStory', querySnapshot.documents[0].data['userStory']);
      prefsObject.setString(
          'gender', querySnapshot.documents[0].data['gender']);
      prefsObject.setString('age', querySnapshot.documents[0].data['age']);
      prefsObject.setString(
          'location', querySnapshot.documents[0].data['location']);
      prefsObject.setString(
          'workingIn', querySnapshot.documents[0].data['workingIn']);
      prefsObject.setString('userSince',
          querySnapshot.documents[0].data['createdOn'].toDate().toString());
      loginBloc.loginValue.sink.add(userUid);
    }
  }

  dynamic checkLoginStream() {
    if (prefsObject.getString('loginUid') != null) {
      loginBloc.loginValue.sink.add(userUid);
    } else {
      print('loginUid Not Found');
    }
  }

  ///This functionality commented because we don't require we change it to simple text note.
//  dynamic createDemo() async {
  // await userDemoBloc.createDemoGenre(userUid);
//  }

  final List<Widget> pages = [
    HomePage(
      key: PageStorageKey('Page1'),
    ),
    MyState(
      key: PageStorageKey('Page2'),
    ),
    MyCategories(
      key: PageStorageKey('Page3'),
    ),
    MyPeopleList(
      key: PageStorageKey('Page4'),
    ),
    AllUsersScreen(
      key: PageStorageKey('Page5'),
    ),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  int _selectedIndex = 2;

  Widget _bottomNavigationBar(int selectedIndex) => BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            return _selectedIndex = index;
          });
        },
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        backgroundColor: mySurfaceColor,
        selectedItemColor: Colors.black45,
        unselectedItemColor: myPrimaryColor,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w700),
        iconSize: 24,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.free_breakfast),
            title: Text(
              Strings.bottomNavigationItem1,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart),
            title: Text(
              Strings.bottomNavigationItem2,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_comfy),
            title: Text(
              Strings.bottomNavigationItem3,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility_new),
            title: Text(
              Strings.bottomNavigationItem4,
            ),
          ),
          BottomNavigationBarItem(
            icon: Badge(
              elevation: 0,
              position: BadgePosition.topLeft(),
              badgeColor: isBadge ? myAccentColor : mySurfaceColor,
              toAnimate: true,
//              borderRadius: 1,
//              badgeContent: Text(
//                '',
//                style: TextStyle(color: myBackgroundColor, fontSize: 10),
//              ),
              child: Icon(Icons.forum),
            ),
            title: Text(
              Strings.bottomNavigationItem5,
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    if (_selectedIndex < 4) {
      return Scaffold(
        body: StreamBuilder<String>(
            stream: loginBloc.loginStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(myOnSurfaceColor),
                  ),
                );
              } else {
                return Scaffold(
                  bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
                  body: PageStorage(
                    child: pages[_selectedIndex],
                    bucket: bucket,
                  ),
                );
              }
            }),
      );
    } else {
      return Scaffold(
        body: StreamBuilder<String>(
            stream: loginBloc.loginStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(myOnSurfaceColor),
                  ),
                );
              } else {
                return Scaffold(
                  bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
                  body: PageStorage(
                    child: pages[_selectedIndex],
                    bucket: bucket,
                  ),
                );
              }
            }),
      );
    }
  }
}
