class Client {
  String clientID;
  List trainers;
  String name;
  String surname;
  String email;
  String pictureUrl;
  List weight;
  double height;
  String healthConditions;
  String phoneNo;
  String lastSessionDate = 'No sessions yet';

  Client(
      {this.clientID = '',
      this.name = '',
      this.surname = '',
      this.email = '',
      this.pictureUrl = '',
      this.weight,
      this.healthConditions = '',
      this.phoneNo = '',
      this.height = 0,
      this.trainers,
      this.lastSessionDate = ''}) {
    this.trainers = this.trainers ?? List<String>();
    this.weight = this.weight ?? List<double>();
  }

  Client.fromMap(Map<String, dynamic> map, String uid) {
    clientID = uid;
    name = map['name'];
    surname = map['surname'];
    email = map['email'];
    pictureUrl = map['pictureUrl'];
    height = map['height'];
    trainers = List<dynamic>.from(map['trainers']);
    weight = List<dynamic>.from(map['weight']);
    healthConditions = map['healthConditions'];
    phoneNo = map['phoneNo'];
    lastSessionDate = map['lastSessionDate'] ?? 'No sessions yet';
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'surname': surname,
        'email': email,
        'trainers': trainers.toSet().toList(),
        'pictureUrl': pictureUrl,
        'weight': weight.toList(),
        'height': height,
        'healthConditions': healthConditions,
        'phoneNo': phoneNo,
        'lastSessionDate': lastSessionDate
      };
}
