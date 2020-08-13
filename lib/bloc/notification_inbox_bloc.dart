import 'package:byebye_flutter_app/firebase_repository/firebase_repository.dart';
import 'package:byebye_flutter_app/network_helper/notification_helper.dart';
import 'package:rxdart/rxdart.dart';

class NotificationInboxBloc {
  final _firebaseRepository = FirebaseRepository();

  BehaviorSubject<List<dynamic>> notificationItem =
      BehaviorSubject<List<dynamic>>();

  Stream<List<dynamic>> get notificationInboxListStream =>
      notificationItem.stream;

  NotificationHelper notificationList;

  dynamic getNotificationList() async {
    notificationList = await _firebaseRepository.onGetNotification();
    notificationItem.sink.add(notificationList.currentUserNotificationList);
  }
}

NotificationInboxBloc notificationInboxBloc = NotificationInboxBloc();
