import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  Notification(
      {DocumentSnapshot notificationResponse,
      String readNotificationId,
      bool read}) {
    notificationId = notificationResponse.documentID;
    title = notificationResponse['title'];
    body = notificationResponse['body'];
    createdOn = notificationResponse['createdAt'].toDate().toString();
    readNotificationID = readNotificationId;
    readValue = read;
  }

  String notificationId;
  String createdOn;
  String title;
  String body;
  String readNotificationID;
  bool readValue;
}
