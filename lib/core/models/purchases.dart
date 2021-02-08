class Purchase {
  int sessions;
  int sessionsCompleted;
  String expiryDate;
  String packageID;
  String purchaseID;

  Purchase(
      {this.sessions, this.sessionsCompleted, this.expiryDate, this.packageID});

  Purchase.fromMap(Map<String, dynamic> map, String uid) {
    purchaseID = uid;
    sessions = map['sessions'];
    sessionsCompleted = map['sessionsCompleted'];
    packageID = map['packageID'];
    expiryDate = map['expiryDate'];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'sessions': sessions,
        'sessionsCompleted': sessionsCompleted,
        'packageID': packageID,
        'expiryDate': expiryDate
      };
}
