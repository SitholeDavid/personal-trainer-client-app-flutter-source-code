import 'package:flutter/cupertino.dart';

class Session {
  String sessionID;
  String startTime;
  String client;
  String clientToken;
  String clientID;

  Session(
      {@required this.sessionID,
      @required this.startTime,
      @required this.client,
      @required this.clientToken,
      @required this.clientID});

  Session.fromMap(Map<String, dynamic> map, String uid) {
    sessionID = uid;
    startTime = map['startTime'];
    client = map['client'];
    clientToken = map['clientToken'] ?? '';
    clientID = map['clientID'];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'startTime': startTime,
        'client': client,
        'clientToken': clientToken ?? '',
        'clientID': clientID
      };
}
