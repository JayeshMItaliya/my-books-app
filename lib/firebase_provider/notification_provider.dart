import 'package:byebye_flutter_app/network_helper/notification_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationProvider {
  final Firestore _firestore = Firestore.instance;
  Future<NotificationHelper> notificationApi() async {
    final Query notificationInboxQuery = _firestore
        .collection('Notification-Inbox')
        .orderBy('createdAt', descending: true);
    final QuerySnapshot notificationInboxQuerySnapshot =
        await notificationInboxQuery.getDocuments();
    final Query readNotificationsQuery =
        _firestore.collection('ReadNotification');
    final QuerySnapshot readNotificationsQuerySnapshot =
        await readNotificationsQuery.getDocuments();
    return NotificationHelper(
      notificationInboxData: notificationInboxQuerySnapshot,
      readNotificationData: readNotificationsQuerySnapshot,
    );
  }
}
