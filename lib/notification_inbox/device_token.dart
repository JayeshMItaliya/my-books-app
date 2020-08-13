import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DeviceToken {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final Firestore _firestore = Firestore.instance;

  Future<void> generateToken() async {
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print('onMessage: $message');
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print('onLaunch: $message');
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print('onResume: $message');
    //   },
    // );
    await _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print('Settings registered: $settings');
    });
    final token = await _firebaseMessaging.getToken().then(
      (String token) async {
        await _firestore
            .collection('users')
            .document(prefsObject.getString('uid'))
            .updateData({'deviceToken': token});
        prefsObject.setString('deviceToken', token);
      },
    );
    return token;
  }
}

DeviceToken deviceToken = DeviceToken();
