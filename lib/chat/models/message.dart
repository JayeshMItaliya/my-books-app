import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  Message(
      {this.senderUid,
      this.receiverUid,
      this.type,
      this.message,
      this.timestamp});

  Message.withoutMessage(
      {this.senderUid,
      this.receiverUid,
      this.type,
      this.timestamp,
      this.photoUrl});

  String senderUid;
  String receiverUid;
  String type;
  String message;
  FieldValue timestamp;
  String photoUrl;

  Map toMap() {
    final map = <String, dynamic>{};
    map['senderUid'] = senderUid;
    map['receiverUid'] = receiverUid;
    map['type'] = type;
    map['message'] = message;
    map['timestamp'] = timestamp;
    return map;
  }

  Message fromMap(Map<String, dynamic> map) {
    final Message _message = Message();
    _message.senderUid = map['senderUid'];
    _message.receiverUid = map['receiverUid'];
    _message.type = map['type'];
    _message.message = map['message'];
    _message.timestamp = map['timestamp'];
    return _message;
  }
}
