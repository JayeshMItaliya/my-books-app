import 'dart:convert';
import 'dart:io' show Platform;
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:intl/intl.dart';

import '../my_constants/design_system.dart';

class NotificationMessage extends StatefulWidget {
  const NotificationMessage({this.item});
  final dynamic item;
  @override
  _NotificationMessageState createState() => _NotificationMessageState();
}

class _NotificationMessageState extends State<NotificationMessage> {
  final flutterWebView = FlutterWebviewPlugin();
  final Firestore _firestoreInstance = Firestore.instance;

  @override
  void initState() {
    _firestoreInstance
        .collection('ReadNotification')
        .document(widget.item.readNotificationID)
        .updateData({'read': true});
    super.initState();
  }

  @override
  void dispose() {
    flutterWebView.dispose();
    flutterWebView.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myBackgroundColor,
      appBar: notificationMessageAppBar(context),
      body: Platform.isIOS
          ? Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: notificationContent(),
            )
          : notificationContent(),
    );
  }

  Widget notificationDescription() {
    return PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: Container(
        width: MediaQuery.of(context).size.width - 50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            notificationTime(),
            SizedBox(height: 12),
            notificationHeader(),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget notificationTime() {
    final DateTime createdOn = DateTime.parse(widget.item.createdOn);
    return Text(
      DateFormat('MMM dd, yyyy').format(createdOn).toUpperCase(),
      style: Theme.of(context)
          .textTheme
          .caption
          .copyWith(color: myOnPrimaryColor, letterSpacing: -0.2),
    );
  }

  Widget notificationHeader() {
    return Text(
      widget.item.title.toString().toUpperCase(),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      style: Theme.of(context)
          .textTheme
          .bodyText2
          .copyWith(color: myOnPrimaryColor, fontSize: 16),
    );
  }

  Widget notificationContent() {
    return WebviewScaffold(
      url: Uri.dataFromString(
        widget.item.body,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
        base64: true,
      ).toString(),
      clearCache: true,
      clearCookies: true,
      withJavascript: true,
      mediaPlaybackRequiresUserGesture: false,
      initialChild: Container(),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      scrollBar: false,
    );
  }

  Widget notificationMessageAppBar(context) {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: myOnPrimaryColor),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      titleSpacing: 0.0,
      bottom: notificationDescription(),
    );
  }
}
