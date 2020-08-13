import 'package:byebye_flutter_app/model/notification.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationHelper {
  NotificationHelper({
    QuerySnapshot notificationInboxData,
    QuerySnapshot readNotificationData,
  }) {
    if (notificationInboxData.documents.isNotEmpty) {
      for (DocumentSnapshot notification in notificationInboxData.documents) {
        if (readNotificationData.documents.isNotEmpty) {
          for (DocumentSnapshot readNotification
              in readNotificationData.documents) {
            if (notification.documentID == readNotification['notificationId']) {
              if (readNotification['uid'] == prefsObject.getString('uid')) {
                currentUserNotificationList.add(Notification(
                    notificationResponse: notification,
                    readNotificationId: readNotification.documentID,
                    read: readNotification['read']));
              }
            }
          }
        }
      }
    }
  }
  var currentUserNotificationList = [];
}
