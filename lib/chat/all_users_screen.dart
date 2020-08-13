import 'dart:async';
import 'package:byebye_flutter_app/chat/chat_screen.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:byebye_flutter_app/constants/strings.dart';
import '../my_constants/design_system.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({Key key}) : super(key: key);

  @override
  _AllUsersScreenState createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen>
    with TickerProviderStateMixin {
  bool activeSearch = false;
  final searchController = TextEditingController();
  TabController tabController;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  StreamSubscription<QuerySnapshot> _subscription;
  List<DocumentSnapshot> usersList;
  List<DocumentSnapshot> userTempList;
  dynamic openChatList;
  dynamic openChatTempList;
  final CollectionReference _collectionReference =
      Firestore.instance.collection('users');
  bool selectUserForDelete = false;
  String selectedDeleteAccountActionButton;
  String selectedUserId;
  List<String> imgList = [];
  String currentUserId = prefsObject.getString('uid');
  bool isLoading = false;
  final _key = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getOpenChatUser();
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {
        if (tabController.index == 1) {
          getOpenChatUser();
        }
      });
    });
    _subscription = _collectionReference
        .orderBy('createdOn', descending: true)
        .snapshots()
        .listen((dataSnapshot) {
      setState(() {
        usersList = dataSnapshot.documents;
        usersList.removeWhere(
            (item) => item.data['uid'] == prefsObject.getString('uid'));
        usersList.removeWhere((item) =>
            item.data['blockedBy'].contains(prefsObject.getString('uid')));
        userTempList = usersList;
      });
    });
    getOpenChatUser();
  }

  dynamic getOpenChatUser() async {
    final Query query = Firestore.instance
        .collection('chatList2')
        .document(currentUserId)
        .collection(currentUserId);
    final QuerySnapshot querySnapshot = await query.getDocuments();
    openChatList = querySnapshot.documents;
    openChatTempList = openChatList;
    setState(() {});
  }

  Future<void> deleteOpenChatUserHistory() async {
    await Firestore.instance
        .collection('chatList2')
        .document(currentUserId)
        .collection(currentUserId)
        .document(selectedUserId)
        .delete()
        .then((onValue) async {
      await _deleteUserFromMessages();
    });
  }

  Future<void> _deleteUserFromMessages() async {
    final String groupId = currentUserId.hashCode <= selectedUserId.hashCode
        ? '$currentUserId-$selectedUserId'
        : '$selectedUserId-$currentUserId';

    await Firestore.instance
        .collection('messages2')
        .document(groupId)
        .collection(groupId)
        .getDocuments()
        .then((onValue) async {
      for (DocumentSnapshot messages in onValue.documents) {
        await Firestore.instance
            .collection('messages2')
            .document(groupId)
            .collection(groupId)
            .document(messages.documentID)
            .get()
            .then((messages) async {
          final String imgurl = messages.data['content'];
          if (imgurl.contains('https://')) {
            deleteUserChatFile(imgurl);
          }
          final DocumentReference messageRef = messages.reference;
          final WriteBatch _batch = Firestore.instance.batch();
          _batch.delete(messageRef);
          await _batch.commit();
        }).then((onValue) {
          getOpenChatUser();
          setState(() {
            isLoading = true;
            selectUserForDelete = false;
          });
          if (isLoading == true) {
            Loader().hideLoader(context);
            _key.currentState.showSnackBar(
              SnackBar(
                backgroundColor: myAccentColor,
                content: Text(
                  Strings.chatDeleted,
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: myOnPrimaryColor),
                ),
                duration: Duration(seconds: 1),
              ),
            );
            setState(() {
              isLoading = false;
            });
          }
        });
      }
    });
  }

  Future deleteUserChatFile(imgUrl) async {
    FirebaseStorage.instance
        .ref()
        .child('ChatMedia')
        .getStorage()
        .getReferenceFromUrl(imgUrl)
        .then((chatImg) {
      chatImg.delete().catchError((onError) {
        print(onError);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: myDarkSurfaceColor,
      appBar: chatAppBar(),
      body: Container(
        child: DefaultTabController(
          length: 2,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: myPrimaryColor,
                      /*border: Border(
                        bottom:
                            BorderSide(width: 1.5, color: myDarkOnPrimaryColor),
                      ),*/
                    ),
                    height: 56,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        TabBar(
                          controller: tabController,
                          indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(
                              width: 4,
                              color: myAccentColor,
                            ),
                            insets: EdgeInsets.only(
                                left: 0, top: 0, right: 0, bottom: 0),
                          ),
                          isScrollable: true,
                          labelPadding: EdgeInsets.only(
                              left: 16, top: 10, right: 12, bottom: 4),
                          tabs: [
                            Tab(
                              child: Text(
                                Strings.chatAvailableTab,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .copyWith(color: myOnPrimaryColor),
                              ),
                            ),
                            Tab(
                              child: Text(
                                Strings.chatOpenChatsTab,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .copyWith(color: myOnPrimaryColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
                Expanded(
                  child: Container(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        //TAB-1
                        Container(
                          child: usersList != null
                              ? Container(
                                  child: ListView.separated(
                                    separatorBuilder: (context, int index) =>
                                        Divider(
                                      indent: 16,
                                      endIndent: 16,
                                      thickness: 0.0,
                                      color: myDarkSurfaceColor,
                                    ),
                                    itemCount: usersList.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        height: 80,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor:
                                                  myOnBackgroundColor,
                                              radius: 24,
                                              backgroundImage: usersList[index]
                                                          .data['photoUrl'] ==
                                                      ''
                                                  ? AssetImage(
                                                      'assets/user.png')
                                                  : NetworkImage(
                                                      usersList[index]
                                                          .data['photoUrl']),
                                            ),
                                            title: Text(
                                              usersList[index].data['name'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4
                                                  .copyWith(
                                                      color:
                                                          myDarkOnPrimaryColor)
                                                    ..copyWith(
                                                        color:
                                                            myDarkOnPrimaryColor),
                                            ),
                                            subtitle: Text(
                                              '${usersList[index].data['location'].toString().toUpperCase()} • ${usersList[index].data['gender'].toString().toUpperCase()} • ${usersList[index].data['age']} • ${usersList[index].data['workingIn'].toString().toUpperCase()}',
                                              maxLines: 2,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .overline
                                                  .copyWith(
                                                      color:
                                                          myDarkOnPrimaryColor),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Chat(
                                                    peerID: usersList[index]
                                                        .data['uid'],
                                                    peerName: usersList[index]
                                                        .data['name'],
                                                    peerUrl: usersList[index]
                                                        .data['photoUrl'],
                                                    peerEmail: usersList[index]
                                                        .data['emailId'],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        myPrimaryColor),
                                  ),
                                ),
                        ),

                        //TAB-2

                        Container(
                          child: openChatList != null
                              ? Container(
                                  child: ListView.separated(
                                    separatorBuilder: (context, int index) =>
                                        Divider(
                                      indent: 16,
                                      endIndent: 16,
                                      thickness: 0.0,
                                      color: myDarkSurfaceColor,
                                    ),
                                    itemCount: openChatList.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onLongPress: () {
                                          selectedUserId =
                                              openChatList[index].data['id'];
                                          setState(() {
                                            selectUserForDelete = true;
                                          });
                                        },
                                        child: Container(
                                          height: 80,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: ListTile(
                                              trailing: openChatList[index]
                                                          .data['badge'] ==
                                                      '0'
                                                  ? Container(
                                                      child: Text(''),
                                                    )
                                                  : Container(
                                                      width: 16,
                                                      height: 16,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                        color: myAccentColor,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          openChatList[index]
                                                                          .data[
                                                                      'badge'] ==
                                                                  '0'
                                                              ? ''
                                                              : openChatList[
                                                                          index]
                                                                      .data[
                                                                  'badge'],
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .caption
                                                              .copyWith(
                                                                  color:
                                                                      myOnPrimaryColor),
                                                        ),
                                                      ),
                                                    ),
                                              leading: CircleAvatar(
                                                radius: 24,
                                                backgroundImage: openChatList[
                                                                    index]
                                                                .data[
                                                            'profileImage'] ==
                                                        ''
                                                    ? AssetImage(
                                                        'assets/user.png')
                                                    : NetworkImage(openChatList[
                                                            index]
                                                        .data['profileImage']),
                                              ),
                                              title: Text(
                                                openChatList[index]
                                                    .data['name'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline4
                                                    .copyWith(
                                                        color:
                                                            myDarkOnPrimaryColor),
                                              ),
                                              subtitle: Text(
                                                openChatList[index]
                                                            .data['type'] ==
                                                        0
                                                    ? openChatList[index]
                                                        .data['content']
                                                    : Strings
                                                        .chatPhotoContentMarkup,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline3
                                                    .copyWith(
                                                        color:
                                                            myDarkOnPrimaryColor),
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  selectUserForDelete = false;
                                                });
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => Chat(
                                                      peerID:
                                                          openChatList[index]
                                                              .data['id'],
                                                      peerName:
                                                          openChatList[index]
                                                              .data['name'],
                                                      peerUrl: openChatList[
                                                              index]
                                                          .data['profileImage'],
                                                      peerEmail:
                                                          openChatList[index]
                                                              .data['email'],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        myPrimaryColor),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget chatAppBar() {
    return AppBar(
      /*backgroundColor: myAccentColor,*/
      elevation: 0,
      centerTitle: false,
      // leading: IconButton(
      //   icon: Icon(Icons.arrow_back, color: myOnPrimaryColor),
      //   onPressed: () => Navigator.of(context).pushAndRemoveUntil(
      //       MaterialPageRoute(
      //         builder: (context) => BottomNavigationBarController(
      //           userUid: prefsObject.getString('uid'),
      //           routeType: NavigateFrom.chat,
      //         ),
      //       ),
      //       (Route<dynamic> route) => false),
      // ),
      titleSpacing: 20.0,
      title: !activeSearch
          ? Text(Strings.chatAppBar,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .copyWith(color: myOnPrimaryColor))
          : TextField(
              autofocus: true,
              onChanged: (value) {
                searchChatUser(value, tabController.index);
              },
              controller: searchController,
              cursorColor: myOnPrimaryColor,
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(color: myOnPrimaryColor),
              decoration: InputDecoration(
                hintText: Strings.inventoryAppBarSearch,
                hintStyle: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: myOnPrimaryColor),
                border: InputBorder.none,
              ),
            ),

      actions: [
        !activeSearch
            ? IconButton(
                icon: Icon(Icons.search, color: myOnPrimaryColor),
                onPressed: () {
                  activeSearch = !activeSearch;
                  setState(() {});
                },
              )
            : IconButton(
                icon: Icon(
                  Icons.clear,
                  color: myOnPrimaryColor,
                ),
                onPressed: () {
                  searchController.clear();
                  searchChatUser('', tabController.index);
                  activeSearch = !activeSearch;
                  setState(() {});
                }),
        selectUserForDelete == true && tabController.index == 1
            ? Padding(
                padding: const EdgeInsets.only(right: 5),
                child: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: myAccentColor,
                    ),
                    onPressed: () async {
                      selectedDeleteAccountActionButton =
                          await AlertBoxDialog().showCustomAlertDialog(
                        context,
                        Strings.deleteChatTitle,
                        Strings.deleteChatContent,
                        [Strings.cancel, Strings.ok],
                      );
                      if (selectedDeleteAccountActionButton == Strings.ok) {
                        if (isLoading == false) {
                          Loader().showLoader(context);
                          deleteOpenChatUserHistory();
                        }
                      } else {
                        setState(() {
                          selectUserForDelete = false;
                        });
                      }
                    }),
              )
            : Container(),
      ],
    );
  }

  dynamic searchChatUser(String searchText, int tabIndex) {
    final List<DocumentSnapshot> searchList = [];
    usersList = [];
    openChatList = [];
    if (searchText.isEmpty) {
      usersList = userTempList;
      openChatList = openChatTempList;
    } else if (tabIndex == 0) {
      for (int i = 0; i < userTempList.length; i++) {
        if (userTempList[i]
            .data['name']
            .toLowerCase()
            .contains(searchText.toLowerCase())) {
          searchList.add(userTempList[i]);
        }
      }
      usersList = searchList;
    } else if (tabIndex == 1) {
      for (int i = 0; i < openChatTempList.length; i++) {
        if (openChatTempList[i]
            .data['name']
            .toLowerCase()
            .contains(searchText.toLowerCase())) {
          searchList.add(openChatTempList[i]);
        }
      }
      openChatList = searchList;
    } else {}
    setState(() {});
  }
}
