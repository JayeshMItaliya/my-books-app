import 'dart:async';
import 'dart:io';
import 'package:byebye_flutter_app/bloc/edit_account_bloc.dart';
import 'package:byebye_flutter_app/chat/full_screen_image.dart';
import 'package:byebye_flutter_app/common_widgets/platform_alert_dialog.dart';
import 'package:byebye_flutter_app/constants/strings.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Chat extends StatefulWidget {
  const Chat({
    @required this.peerID,
    this.peerUrl,
    @required this.peerName,
    this.peerEmail,
  });

  final String peerID;
  final String peerUrl;
  final String peerName;
  final String peerEmail;

  // final Map userData;

  @override
  _ChatState createState() => _ChatState(
        peerID: peerID,
        peerUrl: peerUrl,
        peerName: peerName,
        peerEmail: peerEmail,
      );
}

class _ChatState extends State<Chat> {
  _ChatState(
      {@required this.peerID,
      this.peerUrl,
      @required this.peerName,
      this.peerEmail});

  final String peerID;
  final String peerUrl;
  final String peerName;
  final String peerEmail;

  String groupChatId;
  dynamic listMessage;
  File imageFile;
  bool isLoading;
  String imageUrl;
  int limit = 20;
  Map userDataFromDb = {};
  double screenWidth;

  final imagePicker = ImagePicker();

  final TextEditingController textEditingController = TextEditingController();
  ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  static RegExp validUrl = RegExp(
      r'^(http|ftp|https)://([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?');
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getUserData();
    groupChatId = '';
    isLoading = false;
    imageUrl = '';
    readLocal();
    removeBadge();
    setState(() {});
  }

  dynamic getUserData() async {
    await Firestore.instance
        .collection('users')
        .document(prefsObject.getString('uid'))
        .get()
        .then((user) {
      userDataFromDb = user.data;
      setState(() {});
    });
  }

  Future removeBadge() async {
    await Firestore.instance
        .collection('chatList2')
        .document(prefsObject.getString('uid'))
        .collection(prefsObject.getString('uid'))
        .document(peerID)
        .get()
        .then((data) async {
      if (data.data != null) {
        await Firestore.instance
            .collection('chatList2')
            .document(prefsObject.getString('uid'))
            .collection(prefsObject.getString('uid'))
            .document(peerID)
            .updateData({'badge': '0'});
      }
    });
    // .updateData({'badge': '0'});
  }

  void _scrollListener() {
    if (listScrollController.position.pixels ==
        listScrollController.position.maxScrollExtent) {
      startLoader();
    }
  }

  void startLoader() {
    setState(() {
      isLoading = true;
      fetchData();
    });
  }

  dynamic fetchData() async {
    final _duration = Duration(seconds: 2);
    return Timer(_duration, onResponse);
  }

  void onResponse() {
    setState(() {
      isLoading = false;
      limit = limit + 20;
    });
  }

  void readLocal() {
    if (prefsObject.getString('uid').hashCode <= peerID.hashCode) {
      groupChatId = '${prefsObject.getString('uid')}-$peerID';
    } else {
      groupChatId = '$peerID-${prefsObject.getString('uid')}';
    }

    Firestore.instance
        .collection('users')
        .document(prefsObject.getString('uid'))
        .updateData({'chattingWith': peerID});

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    listScrollController = ScrollController()..addListener(_scrollListener);
    return Scaffold(
      backgroundColor: myDarkBackgroundColor,
      key: _key,
      appBar: chatScreenAppBar(),
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages2
              buildListMessage(),

              // Input content
              buildInput(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: isLoading
                ? Center(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          myAccentColor,
                        ),
                      ),
                    ),
                  )
                : Container(),
          )
        ],
      ),
    );
  }

  Widget chatScreenAppBar() {
    return AppBar(
      /*backgroundColor: myAccentColor,*/
      centerTitle: false,
      elevation: 4,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: myOnPrimaryColor),
        onPressed: () => {Navigator.pop(context)},
      ),
      titleSpacing: 0.0,
      title: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              backgroundImage: widget.peerUrl == ''
                  ? AssetImage('assets/user.png')
                  : NetworkImage(widget.peerUrl),
              radius: 16.0,
            ),
          ),
          Text(
            widget.peerName,
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: myOnPrimaryColor),
          ),
        ],
      ),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(myAccentColor),
              ),
            )
          : StreamBuilder(
              stream: Firestore.instance
                  .collection('messages2')
                  .document(groupChatId)
                  .collection(groupChatId)
                  .orderBy('timestamp', descending: true)
                  .limit(limit)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(myAccentColor),
                    ),
                  );
                } else {
                  listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: EdgeInsets.all(0.0),
                    //previously 10 marius
                    itemBuilder: (context, index) =>
                        buildItem(index, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }

  dynamic chooseSourceOfPhoto(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 72,
            color: myBackgroundColor,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      _cameraPicker();
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.photo_camera),
                    color: myAccentColor,
                    iconSize: 32.0,
                  ),
                  IconButton(
                    onPressed: () {
                      _galleryPicker();
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.photo_library),
                    color: myAccentColor,
                    iconSize: 32.0,
                  )
                ],
              ),
            ),
          );
        });
  }

  dynamic _cameraPicker() async {
    final captureFile = await imagePicker.getImage(
        source: ImageSource.camera, imageQuality: 50);

    final File cameraImage = File(captureFile.path);
    if (cameraImage != null) {
      final compressedImage =
          await editAccountBloc.compressImage(cameraImage, screenWidth.toInt());
      final uploadImageSizeInMb = compressedImage.lengthSync() / 1000000;
      if (uploadImageSizeInMb > 2.0) {
        PlatformAlertDialog(
          title: Strings.fileSize,
          content: Strings.fileSizeError,
          defaultActionText: Strings.cancel,
        ).show(context);
      } else {
        setState(() {
          isLoading = true;
        });
        uploadFile(compressedImage);
      }
    }
  }

  dynamic _galleryPicker() async {
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    final File galleryImage = File(pickedFile.path);
    if (galleryImage != null) {
      final compressedImage = await editAccountBloc.compressImage(
          galleryImage, screenWidth.toInt());
      final uploadImageSizeInMb = compressedImage.lengthSync() / 1000000;
      if (uploadImageSizeInMb > 2.0) {
        PlatformAlertDialog(
          title: Strings.fileSize,
          content: Strings.fileSizeError,
          defaultActionText: Strings.cancel,
        ).show(context);
      } else {
        setState(() {
          isLoading = true;
        });
        uploadFile(compressedImage);
      }
    }
  }

  Future uploadFile(image) async {
    final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final StorageReference reference =
        FirebaseStorage.instance.ref().child('ChatMedia').child(fileName);

    final StorageUploadTask uploadTask = reference.putFile(image);
    final StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document['idFrom'] == prefsObject.getString('uid')) {
      // Right (my message)
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              document['type'] == 0
                  // Text
                  ? GestureDetector(
                      onLongPress: () {
                        Clipboard.setData(
                            ClipboardData(text: document['content']));
                        _key.currentState.showSnackBar(
                          SnackBar(
                            backgroundColor: myAccentColor,
                            content: Text(
                              Strings.chatScreenCopy,
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(color: myOnPrimaryColor),
                            ),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      onTap: validUrl.hasMatch(document['content'])
                          ? () {
                              launchUrl(document['content']);
                            }
                          : () {},
                      child: Container(
                        //sent message

                        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                        width: MediaQuery.of(context).size.width - 48,
                        decoration: BoxDecoration(
                          color: myPrimaryColor,
                          /*color: myDarkSurfaceColor,*/
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        margin: EdgeInsets.only(
                            bottom: isLastMessageRight(index) ? 10.0 : 10.0,
                            right: 24,
                            left: 24),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                          child: Text(
                            document['content'],
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                .copyWith(
                                  fontSize: 13,
                                  color: validUrl.hasMatch(document['content'])
                                      ? myErrorColor
                                      : myDarkOnPrimaryColor,
                                  decoration:
                                      validUrl.hasMatch(document['content'])
                                          ? TextDecoration.underline
                                          : null,
                                ),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      //photo message
                      child: FlatButton(
                        child: Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      myAccentColor),
                                ),
                              ),
                              width: MediaQuery.of(context).size.width - 48,
                              height: 200.0,
                              padding: EdgeInsets.all(70.0),
                              decoration: BoxDecoration(
                                color: myPrimaryColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4.0),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Material(
                              child: Text(Strings.chatScreenNotAvailable),
                              borderRadius: BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                            imageUrl: document['content'],
                            width: MediaQuery.of(context).size.width - 48,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(4.0),
                          ),
                          clipBehavior: Clip.hardEdge,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  FullScreenImage(
                                photoUrl: document['content'],
                              ),
                            ),
                          );
                        },
                        padding: EdgeInsets.all(0),
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastMessageRight(index) ? 10.0 : 10.0,
                          left: 24,
                          right: 24),
                    ),
            ],
            mainAxisAlignment: MainAxisAlignment.end,
          ),
          isLastMessageRight(index)
              ? Container(
                  padding: EdgeInsets.fromLTRB(24, 0, 0, 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: myPrimaryColor,
                        child: Icon(Icons.arrow_upward,
                            size: 16, color: myDarkOnPrimaryColor),
                      ),
                      SizedBox(width: 5),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          DateFormat('dd MMM hh:mm a').format(
                            DateTime.fromMillisecondsSinceEpoch(
                              int.parse(
                                document['timestamp'],
                              ),
                            ),
                          ),
                          style: TextStyle(
                            color: mySurfaceColor,
                            fontSize: 10.0,
                            /*fontStyle: FontStyle.italic*/
                          ),
                        ),
                        margin: EdgeInsets.only(right: 0.0),
                      ),
                    ],
                  ),
                )
              : Container()
        ],
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                document['type'] == 0
                    ? Container(
                        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                        width: MediaQuery.of(context).size.width - 48,
                        decoration: BoxDecoration(
                          color: myDarkAccentColor,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        margin: EdgeInsets.only(
                            bottom: isLastMessageRight(index) ? 10.0 : 10.0,
                            left: 24,
                            right: 24),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                          child: Text(
                            document['content'],
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                .copyWith(
                                    fontSize: 13, color: myBackgroundColor),
                          ),
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.only(left: 24, right: 24),
                        child: FlatButton(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Material(
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Container(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      myAccentColor),
                                ),
                                width: MediaQuery.of(context).size.width - 48,
                                height: 200.0,
                                padding: EdgeInsets.all(70.0),
                                decoration: BoxDecoration(
                                  color: myOnBackgroundColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4.0),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Material(
                                child: Text(Strings.chatScreenNotAvailable),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4.0),
                                ),
                                clipBehavior: Clip.hardEdge,
                              ),
                              imageUrl: document['content'],
                              width: MediaQuery.of(context).size.width - 48,
                              height: 200.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                            clipBehavior: Clip.hardEdge,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    FullScreenImage(
                                  photoUrl: document['content'],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
                    padding: EdgeInsets.fromLTRB(24, 0, 0, 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: myDarkAccentColor,
                          child: Icon(Icons.arrow_downward,
                              color: myDarkOnPrimaryColor, size: 16),
                        ),
                        SizedBox(width: 5),
                        Text(
                          DateFormat('dd MMM hh:mm a').format(
                            DateTime.fromMillisecondsSinceEpoch(
                              int.parse(
                                document['timestamp'],
                              ),
                            ),
                          ),
                          style: TextStyle(
                            color: mySurfaceColor,
                            fontSize: 10.0,
                            /*fontStyle: FontStyle.italic*/
                          ),
                        ),
                      ],
                    ),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] == prefsObject.getString('uid')) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] != prefsObject.getString('uid')) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  String contentMsg = '';

  void onSendMessage(String content, int type) {
    int badgeCount = 0;
    if (content.trim() != '') {
      setState(() {
        contentMsg = textEditingController.text;
      });
      textEditingController.clear();

      final documentReference = Firestore.instance
          .collection('messages2')
          .document(groupChatId)
          .collection(groupChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': prefsObject.getString('uid'),
            'idTo': peerID,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type,
          },
        );
      }).then((onValue) async {
        await Firestore.instance
            .collection('chatList2')
            .document(prefsObject.getString('uid'))
            .collection(prefsObject.getString('uid'))
            .document(peerID)
            .setData({
          'id': peerID,
          'name': peerName,
          'email': peerEmail,
          'type': type,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'content': content,
          'badge': '0',
          'profileImage': peerUrl,
        }).then((onValue) async {
          try {
            await Firestore.instance
                .collection('chatList2')
                .document(peerID)
                .collection(peerID)
                .document(prefsObject.getString('uid'))
                .get()
                .then((doc) async {
              debugPrint(doc.data['badge']);
              if (doc.data['badge'] != null) {
                badgeCount = int.parse(doc.data['badge']);
                await Firestore.instance
                    .collection('chatList2')
                    .document(peerID)
                    .collection(peerID)
                    .document(prefsObject.getString('uid'))
                    .setData({
                  'id': prefsObject.getString('uid'),
                  'name': "${userDataFromDb['name']}",
                  'email': "${userDataFromDb['emailId']}",
                  'type': type,
                  'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
                  'content': content,
                  'badge': '${badgeCount + 1}',
                  'profileImage': userDataFromDb['photoUrl'],
                });
              }
            });
          } catch (e) {
            await Firestore.instance
                .collection('chatList2')
                .document(peerID)
                .collection(peerID)
                .document(prefsObject.getString('uid'))
                .setData({
              'id': prefsObject.getString('uid'),
              'name': "${userDataFromDb['name']}",
              'email': "${userDataFromDb['emailId']}",
              'type': type,
              'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
              'content': content,
              'badge': '${badgeCount + 1}',
              'profileImage': userDataFromDb['photoUrl'],
            });
            print(e);
          }
        });
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {}
  }

  dynamic launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw Strings.chatScreenCouldNotLaunch + '$url';
    }
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: Container(
              padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: IconButton(
                icon: Icon(
                  Icons.image,
                  color: myOnBackgroundColor,
                ),
                onPressed: () {
                  chooseSourceOfPhoto(context);
                },
                // color: primaryColor,
              ),
            ),
            color: myBackgroundColor,
          ),

          // Edit text
          Flexible(
            child: Container(
              color: myBackgroundColor,
              child: TextField(
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(fontSize: 14, color: myOnBackgroundColor),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: Strings.chatScreenTypeMessage,
                  hintStyle: TextStyle(color: myOnBackgroundColor),
                ),
                // focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: Container(
              color: myBackgroundColor,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(
                  Icons.send,
                  color: myOnBackgroundColor,
                ),
                onPressed: () {
                  onSendMessage(textEditingController.text, 0);
                },
                // color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 56.0,
      decoration: BoxDecoration(
        color: myBackgroundColor,
        border: Border(
          top: BorderSide(color: myOnBackgroundColor, width: 0.7),
        ),
      ),
    );
  }
}
