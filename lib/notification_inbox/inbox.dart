import 'dart:io' show Platform;
import 'package:byebye_flutter_app/bloc/notification_inbox_bloc.dart';
import 'package:byebye_flutter_app/constants/strings.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:byebye_flutter_app/notification_inbox/notification_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:intl/intl.dart';

class NotificationInbox extends StatefulWidget {
  @override
  _NotificationInboxState createState() => _NotificationInboxState();
}

class _NotificationInboxState extends State<NotificationInbox> {
  NotificationInboxBloc notificationInboxBloc = NotificationInboxBloc();
  DateTime currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    notificationInboxBloc.getNotificationList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myInboxAppBar(context),
      body: StreamBuilder(
          stream: notificationInboxBloc.notificationInboxListStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(myPrimaryColor),
                ),
              );
            } else {
              if (snapshot.data.isEmpty) {
                return Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      Strings.notificationNotAvailable,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(color: myOnSurfaceColor),
                    ),
                  ),
                );
              }
            }
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return notificationTile(context, snapshot.data[index]);
              },
            );
          }),
    );
  }

  Widget notificationTile(BuildContext context, dynamic item) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationMessage(item: item),
          ),
        ).then(
          (value) => notificationInboxBloc.getNotificationList(),
        );
      },
      child: Container(
        padding: EdgeInsets.only(top: 15, bottom: 15),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0, color: myOnBackgroundColor),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width - 45,
                  padding: EdgeInsets.only(left: 25, right: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      notificationTime(context, item),
                      SizedBox(height: 12),
                      notificationHeader(context, item),
                    ],
                  ),
                ),
                !item.readValue
                    ? Icon(Icons.fiber_new, color: myOnBackgroundColor)
                    : Container(),
              ],
            ),
            Platform.isIOS
                ? SizedBox(height: 0)
                : notificationContent(context, item),
          ],
        ),
      ),
    );
  }

  Widget notificationTime(context, dynamic item) {
    final DateTime createdOn = DateTime.parse(item.createdOn);
    return Text(
      DateFormat('MMM dd, yyyy').format(createdOn).toUpperCase(),
      style: Theme.of(context)
          .textTheme
          .caption
          .copyWith(color: myOnBackgroundColor, letterSpacing: -0.2),
    );
  }

  Widget notificationHeader(context, dynamic item) {
    return Text(
      item.title.toString().toUpperCase(),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodyText2.copyWith(
          color: myOnBackgroundColor, fontSize: 16, letterSpacing: -0.2),
    );
  }

  Widget notificationContent(context, dynamic item) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 15),
      height: 43,
      child: Html(
        data: item.body,
        shrinkWrap: true,
        onLinkTap: null,
        onImageTap: null,
        style: {
          'html': Style(
            fontWeight: FontWeight.w500,
            fontFamily: 'Montserrat',
            fontSize: FontSize(12),
          ),
        },
      ),
    );
  }

  Widget myInboxAppBar(context) {
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
      title: Text(
        Strings.drawerNotificationsInbox,
        style: Theme.of(context)
            .textTheme
            .subtitle2
            .copyWith(color: myOnPrimaryColor),
      ),
    );
  }
}
