import 'dart:async';
import 'dart:io' show Platform;

import 'package:byebye_flutter_app/app/account_preferences.dart';
import 'package:byebye_flutter_app/app/account_story.dart';
import 'package:byebye_flutter_app/app/sign_in/sign_in_page.dart';
import 'package:byebye_flutter_app/bloc/genre_bloc.dart';
import 'package:byebye_flutter_app/bloc/user_info_bloc.dart';
import 'package:byebye_flutter_app/common_widgets/avatar.dart';
import 'package:byebye_flutter_app/common_widgets/platform_alert_dialog.dart';
import 'package:byebye_flutter_app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:byebye_flutter_app/constants/strings.dart';
import 'package:byebye_flutter_app/library/item_list.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:byebye_flutter_app/notification_inbox/inbox.dart';
import 'package:byebye_flutter_app/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import '../my_constants/design_system.dart';

class SideDrawer extends StatefulWidget {
  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  final dateFormat = DateFormat('MM/yyyy');
  String userSince = '';
  String selectedDeleteAccountActionButton;
  String currentUserUid;
  final firestoreInstance = Firestore.instance;
  final List<dynamic> chatUserList = [];
  bool isLoding = false;

  Future<void> _signOut(BuildContext context) async {
    try {
      final AuthService auth = Provider.of<AuthService>(context, listen: false);
      Firestore.instance
          .collection('users')
          .document(prefsObject.getString('uid'))
          .updateData({'activeTime': DateTime.now()});
      await auth.signOut();
    } on PlatformException catch (e) {
      await PlatformExceptionAlertDialog(
        title: Strings.logoutFailed,
        exception: e,
      ).show(context);
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final bool didRequestSignOut = await PlatformAlertDialog(
      title: Strings.logout,
      content: Strings.logoutAreYouSure,
      cancelActionText: Strings.cancel,
      defaultActionText: Strings.logout,
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  Future<void> _deleteAccount(BuildContext context) async {
    if (currentUserUid != '') {
      await _deleteUserFromLibrary();
      await _deleteUserFromGenres();
      await _deleteUserFromChatList();
      await _deleteUserFromUsers();
      await _deleteUserAuth();
    }
  }

  Future<void> _deleteUserFromLibrary() async {
    await firestoreInstance
        .collection('library')
        .where('uid', isEqualTo: currentUserUid)
        .getDocuments()
        .then((libraries) async {
      for (DocumentSnapshot library in libraries.documents) {
        final DocumentReference libraryRef = library.reference;
        final WriteBatch _batch = Firestore.instance.batch();
        _batch.delete(libraryRef);
        await _batch.commit();
      }
    });
  }

  Future<void> _deleteUserFromGenres() async {
    await firestoreInstance
        .collection('genres')
        .where('uid', isEqualTo: currentUserUid)
        .getDocuments()
        .then((genreses) async {
      for (DocumentSnapshot genres in genreses.documents) {
        final DocumentReference genresRef = genres.reference;
        final WriteBatch _batch = Firestore.instance.batch();
        _batch.delete(genresRef);
        await _batch.commit();
      }
    });
  }

  Future<void> _deleteUserFromChatList() async {
    await firestoreInstance
        .collection('chatList2')
        .document(currentUserUid)
        .collection(currentUserUid)
        .getDocuments()
        .then((chatList) async {
      chatUserList.addAll(chatList.documents);
      for (DocumentSnapshot chat in chatList.documents) {
        final String peerUid = chat['id'];
        final DocumentReference chatRef = chat.reference;
        final WriteBatch _batch = Firestore.instance.batch();
        _batch.delete(chatRef);
        await _batch.commit();
        await firestoreInstance
            .collection('chatList2')
            .document(peerUid)
            .collection(peerUid)
            .document(currentUserUid)
            .get()
            .then((chat) async {
          final DocumentReference chatRef = chat.reference;
          final WriteBatch _batch = Firestore.instance.batch();
          _batch.delete(chatRef);
          await _batch.commit();
        });
      }
    });
    Future.delayed(Duration(seconds: 1))
        .then((onValue) => _deleteUserFromMessages());
  }

  Future<void> _deleteUserFromMessages() async {
    for (DocumentSnapshot chatUser in chatUserList) {
      final String groupId = currentUserUid.hashCode <= chatUser['id'].hashCode
          ? '$currentUserUid-${chatUser['id']}'
          : '${chatUser['id']}-$currentUserUid';

      await firestoreInstance
          .collection('messages2')
          .document(groupId)
          .collection(groupId)
          .getDocuments()
          .then((messagesList) async {
        for (DocumentSnapshot messages in messagesList.documents) {
          await firestoreInstance
              .collection('messages2')
              .document(groupId)
              .collection(groupId)
              .document(messages.documentID)
              .get()
              .then((messages) async {
            final DocumentReference messageRef = messages.reference;
            final WriteBatch _batch = Firestore.instance.batch();
            _batch.delete(messageRef);
            await _batch.commit();
          });
        }
      });
    }
  }

  Future<void> _deleteUserFromUsers() async {
    await firestoreInstance
        .collection('users')
        .where('uid', isEqualTo: currentUserUid)
        .getDocuments()
        .then((users) async {
      for (DocumentSnapshot user in users.documents) {
        final DocumentReference userRef = user.reference;
        final WriteBatch _batch = Firestore.instance.batch();
        _batch.delete(userRef);
        await _batch.commit();
      }
    });
  }

  Future<void> _deleteUserAuth() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    await user.delete().then((onValue) async {
      prefsObject.setString('uid', null);
      prefsObject.setString('loginUid', null);
      prefsObject.setString('name', null);
      prefsObject.setString('emailId', null);
      prefsObject.setString('gender', null);
      prefsObject.setString('age', null);
      prefsObject.setString('location', null);
      prefsObject.setString('workingIn', null);
      setState(() {
        isLoding = true;
      });
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignInPageBuilder(),
        ),
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userInfoBloc.getUserLibraryInfo(prefsObject.getString('uid'));
    currentUserUid = prefsObject.getString('uid');
  }

  @override
  Widget build(BuildContext context) {
    if (prefsObject.getString('userSince') == null ||
        prefsObject.getString('userSince').isEmpty) {
      userSince = '';
    } else {
      final parsedDate = DateTime.parse(prefsObject.get('userSince'));
      userSince = dateFormat.format(parsedDate);
    }
    return Drawer(
      child: ListView(
        children: [
          //THE BIG HEADER STARTS //
          Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 154,
                    color: myPrimaryColor,
                  ),
/*                  Container(
                    height: 60,
                    color: myPrimaryColor,
                  ),*/
                ],
              ),
              Container(
                padding: EdgeInsets.fromLTRB(24, 32, 0, 0),
                child: Text(
                  prefsObject.getString('name').isEmpty
                      ? 'Anonymous'
                      : prefsObject.getString('name'),
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(color: myOnPrimaryColor),
                ),
              ),

              Container(
                padding: EdgeInsets.fromLTRB(24, 60, 0, 0),
                child: Text(
                  Strings.drawerUserSince + ' ' + '$userSince',
                  style: Theme.of(context).textTheme.caption.copyWith(
                        color: myOnPrimaryColor,
                      ),
                ),
              ),

              Container(
                padding: EdgeInsets.fromLTRB(24, 116, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          child: Container(
                            height: 36,
                            color: myPrimaryColor,
                            /*padding: EdgeInsets.only(right: 20),*/
                            child: Center(
                              child: Text(
                                Strings.drawerMyStory,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(color: myOnPrimaryColor),
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (context) => MyAccountStory(),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 20),
                        GestureDetector(
                          child: Container(
                            height: 36,
                            color: myPrimaryColor,
                            child: Center(
                              child: Text(
                                Strings.drawerInvite,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(color: myOnPrimaryColor),
                              ),
                            ),
                          ),
                          onTap: () => Share.share(Strings.shareText,
                              subject: Strings.shareSubject),
                        ),
                      ],
                    ),
                    GestureDetector(
                      child: Container(
                        height: 36,
                        color: myPrimaryColor,
                        padding: EdgeInsets.only(right: 16),
                        child: Center(
                          child: Text(
                            Strings.drawerMyAccount,
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(color: myOnPrimaryColor),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push<dynamic>(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (context) => MyAccountPreferences(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

// AVATAR START
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Avatar(
                      photoUrl: prefsObject.getString('photoUrl') == ''
                          ? null
                          : prefsObject.getString('photoUrl'),
                      radius: 32,
                      borderColor: Colors.black54,
                      borderWidth: 0.0,
                    ),
                  ),
                ],
              ),
              // AVATAR END
            ],
          ),
          // THE BIG HEADER ENDS //

          // HORIZONTAL SCROLL STARTS //
          Container(
            height: 72,
            color: myAccentColor,
            child: StreamBuilder<dynamic>(
              stream: userInfoBloc.userInfoStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data.isEmpty) {
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      MyHorizontalReportTile(Strings.drawerViews, 0),
                      MyHorizontalReportTile(Strings.drawerFans, 0),
                    ],
                  );
                } else {
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      MyHorizontalReportTile(
                          Strings.drawerViews, snapshot.data[0].toString()),
                      MyHorizontalReportTile(
                          Strings.drawerFans, snapshot.data[1].toString()),
                    ],
                  );
                }
              },
            ),
          ),
          // HORIZONTAL SCROLL ENDS //

          MyDrawerTileHeader(Strings.drawerNotifications),
          myDrawerNotificatioInboxTile(),
          MyLinkTile(9, Strings.drawerWhatsNewOnTheBlog),

          MyDrawerTileHeader(Strings.drawerInventory),
          StreamBuilder<dynamic>(
            stream: userInfoBloc.userGenreStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              } else {
                return snapshot.data.isEmpty
                    ? Container(
                        height: 56,
                        margin: EdgeInsets.only(
                            left: 0, top: 0, right: 0, bottom: 0),
                        padding: EdgeInsets.only(
                            left: 24, top: 12, right: 24, bottom: 12),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          Strings.drawerEmptyInventory,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(color: myOnBackgroundColor),
                        ),
                      )
                    : Container(
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.length,
                          shrinkWrap: true,
                          itemBuilder: (context, int index) {
                            return myDrawerTile(snapshot.data, index);
                          },
                        ),
                      );
              }
            },
          ),

          MyDrawerTileHeader(Strings.drawerTogether),
          MyLinkTile(0, Strings.drawerSupport),
          MyLinkTile(1, Strings.drawerFollow),
          MyLinkTile(2, Strings.drawerShare),
          MyLinkTile(3, Strings.drawerBugReport),
          MyLinkTile(4, Strings.drawerFeedbackIdeas),
          MyLinkTile(5, Strings.drawerRateApp),
          MyLinkTile(6, Strings.drawerCommunity),
          MyLinkTile(7, Strings.drawerHelp),
          MyLinkTile(8, Strings.drawerThanks),

          //Delete Account

          GestureDetector(
            onTap: () async {
              selectedDeleteAccountActionButton =
                  await AlertBoxDialog().showCustomAlertDialog(
                context,
                Strings.deleteAccountPermanent,
                Strings.deleteAccountContent,
                [Strings.cancel, Strings.ok],
              );
              if (selectedDeleteAccountActionButton == Strings.ok) {
                if (isLoding == false) {
                  Loader().showLoader(context);
                  _deleteAccount(context);
                }
              } else {
                Navigator.pop(context);
              }
            },
            child: Container(
              height: 56,
              margin: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
              padding:
                  EdgeInsets.only(left: 24, top: 12, right: 24, bottom: 12),
              decoration: BoxDecoration(
                color: myOnBackgroundColor,
                border: Border(
                  bottom: BorderSide(width: 0.5, color: mySurfaceColor),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Strings.drawerDeleteAccount,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: myOnPrimaryColor),
                  ),
                  Icon(Icons.delete, color: myOnPrimaryColor, size: 16),
                ],
              ),
            ),
          ),

          //Logout
          GestureDetector(
            onTap: () => _confirmSignOut(context),
            child: Container(
              height: 56,
              margin: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
              padding:
                  EdgeInsets.only(left: 24, top: 12, right: 24, bottom: 12),
              decoration: BoxDecoration(
                color: myOnBackgroundColor,
                border: Border(
                  bottom: BorderSide(width: 1, color: mySurfaceColor),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Strings.drawerLogOut,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: myOnPrimaryColor),
                  ),
                  Icon(Icons.power_settings_new,
                      color: myOnPrimaryColor, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget myDrawerNotificatioInboxTile() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => NotificationInbox(),
          ),
        );
      },
      child: Container(
        height: 56,
        padding: EdgeInsets.only(left: 24, top: 12, right: 24, bottom: 12),
        decoration: BoxDecoration(
          color: myBackgroundColor,
          border: Border(
            bottom: BorderSide(width: 1, color: mySurfaceColor),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(Strings.drawerNotificationsInbox,
                style: Theme.of(context).textTheme.bodyText2),
            Icon(Icons.mail, color: myAccentColor, size: 20),
          ],
        ),
      ),
    );
  }

  Widget myDrawerTile(genreList, int index) {
    return GestureDetector(
      onTap: () {
        genreBloc.genreList(prefsObject.getString('uid'));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => MyItemList(
              genreDetails: genreList[index],
            ),
          ),
        );
      },
      child: Container(
        height: 56,
        margin: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
        padding: EdgeInsets.only(left: 24, top: 12, right: 24, bottom: 12),
        decoration: BoxDecoration(
          color: myBackgroundColor,
          border: Border(
            bottom: BorderSide(width: 1, color: mySurfaceColor),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                child: Text(genreList[index].genreName.toString().toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyText2),
              ),
            ),
            Icon(Icons.arrow_forward, color: myOnBackgroundColor, size: 16),
          ],
        ),
      ),
    );
  }
}

class MyDrawerTileHeader extends StatelessWidget {
  const MyDrawerTileHeader(this.myDrawerTileHeaderField);

  final String myDrawerTileHeaderField;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      margin: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
      padding: EdgeInsets.only(left: 24, top: 12, right: 24, bottom: 12),
      decoration: BoxDecoration(
        color: myOnBackgroundColor,
        border: Border(),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/my_application_settings');
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$myDrawerTileHeaderField',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .copyWith(color: myOnPrimaryColor),
            ),
          ],
        ),
      ),
    );
  }
}

class MyDrawerTile extends StatelessWidget {
  const MyDrawerTile(this.myDrawerTileField);

  final String myDrawerTileField;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      margin: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
      padding: EdgeInsets.only(left: 24, top: 12, right: 24, bottom: 12),
      decoration: BoxDecoration(
        color: myBackgroundColor,
        border: Border(
          bottom: BorderSide(width: 1, color: mySurfaceColor),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (context) => MyAccountPreferences(),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$myDrawerTileField',
                style: Theme.of(context).textTheme.bodyText2),
            Icon(Icons.arrow_forward, color: myOnBackgroundColor, size: 16),
          ],
        ),
      ),
    );
  }
}

class MyHorizontalReportTile extends StatelessWidget {
  const MyHorizontalReportTile(
      this.myHorizontalReportTileHeader, this.myHorizontalReportTileValue);

  final String myHorizontalReportTileHeader;
  final dynamic myHorizontalReportTileValue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/my_marketplace');
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(24, 16, 8, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text(
                '$myHorizontalReportTileHeader',
                style: Theme.of(context).textTheme.caption.copyWith(
                      color: myBackgroundColor,
                    ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Text(
                '$myHorizontalReportTileValue',
                style: Theme.of(context).textTheme.headline5.copyWith(
                      color: myBackgroundColor,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyLinkTile extends StatelessWidget {
  MyLinkTile(this._linkIndex, this.myLinkTileField);

  final int _linkIndex;
  final List<Icon> _linkIcon = [
    Icon(Icons.free_breakfast, color: myOnBackgroundColor, size: 20),
    Icon(Icons.title, color: myOnBackgroundColor, size: 16),
    Icon(Icons.share, color: myOnBackgroundColor, size: 16),
    Icon(Icons.adb, color: myOnBackgroundColor, size: 16),
    Icon(Icons.insert_comment, color: myOnBackgroundColor, size: 16),
    Icon(Icons.thumb_up, color: myOnBackgroundColor, size: 16),
    Icon(Icons.group, color: myOnBackgroundColor, size: 16),
    Icon(Icons.build, color: myOnBackgroundColor, size: 16),
    Icon(Icons.local_bar, color: myOnBackgroundColor, size: 16),
    Icon(Icons.new_releases, color: myOnBackgroundColor, size: 20),
  ];

  final List<String> _myLinkURL = [
    'https://www.buymeacoffee.com/byebye',
    'https://www.twitter.com/byebyeapp',
    '',
    'https://www.byebye.io/community/forum/bugs/',
    'https://www.byebye.io/community/',
    Platform.isIOS
        ? 'https://apps.apple.com/gb/app/byebye-declutter/id1502924762'
        : 'https://play.google.com/store/apps/details?id=io.byebye.inventory', //platform specific link to rate in AppStore or GooglePlay
    'https://www.byebye.io/community/',
    'https://www.byebye.io/help/',
    'https://www.byebye.io/contributors/',
    'https://www.byebye.io/blog/',
  ];

  static List<Future> myActions = [
    null,
    null,
    Share.share(Strings.shareText, subject: Strings.shareSubject),
    null,
    null,
    null,
    null,
    null,
    null,
    null,
  ];

  final String myLinkTileField;

  dynamic _launchURL(_myLinkURL) async {
    if (await canLaunch(_myLinkURL)) {
      await launch(_myLinkURL);
    } else {
      throw Strings.chatScreenCouldNotLaunch + ' $_myLinkURL';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _myLinkURL[_linkIndex] != ''
          ? _launchURL(_myLinkURL[_linkIndex])
          : myActions[_linkIndex],
      child: Container(
        height: 56,
        margin: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
        padding: EdgeInsets.only(left: 24, top: 12, right: 24, bottom: 12),
        decoration: BoxDecoration(
          color: myBackgroundColor,
          border: Border(
            bottom: BorderSide(width: 1, color: mySurfaceColor),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /*SizedBox(width: 12),*/
            Text('$myLinkTileField',
                style: Theme.of(context).textTheme.bodyText2),
            Spacer(),
            Container(
              child: _linkIcon[_linkIndex],
            ),
            /*Icon(Icons.arrow_forward, size: 16,color: myOnBackgroundColor),*/
          ],
        ),
      ),
    );
  }
}
