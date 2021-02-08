class Notification {
  String sessionID;
  int notificationID;

  Notification({this.sessionID, this.notificationID});

  Notification.fromMap(Map<String, dynamic> map) {
    sessionID = map['sessionID'];
    notificationID = map['id'];
  }
}
