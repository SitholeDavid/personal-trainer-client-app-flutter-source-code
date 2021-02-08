class Package {
  int id;
  String packageID;
  String title;
  double price;
  String description;
  int noSessions;
  String expiryDate;
  String datePurchased;

  Package(
      {this.id,
      this.packageID = 'not set',
      this.title = '',
      this.price = 0.0,
      this.description = '',
      this.noSessions = 0,
      this.expiryDate = '',
      this.datePurchased = 'not set'});

  Package.fromMap(Map<String, dynamic> map, String uid) {
    id = map['id'] ?? 0;
    packageID = uid;
    title = map['title'];
    price = map['price'];
    description = map[
        'summary']; //SQLITE does not accept 'description' as column name, rename to summary for storage
    noSessions = map['noSessions'];
    expiryDate = map['expiryDate'];
    datePurchased = map['datePurchased'] ?? 0;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map;

    map['title'] = title;
    map['price'] = price;
    map['summary'] =
        description; //SQLITE does not accept 'description' as column name, rename to summary for storage
    map['noSessions'] = noSessions;
    map['expiryDate'] = expiryDate;
    map['datePurchased'] = datePurchased;

    return map;
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'price': price,
        'summary': description,
        'noSessions': noSessions,
        'expiryDate': expiryDate,
        'datePurchased': datePurchased
      };
}
