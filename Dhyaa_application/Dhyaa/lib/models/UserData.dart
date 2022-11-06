class UserData {
  late String id;
  late String email;
  late String majorSubjects;
  late String degree;
  late String location;
  late String phone;
  late String userId;
  late String username;
  late String type;

  UserData(this.email, this.majorSubjects, this.degree, this.location,
      this.phone, this.userId, this.username, this.type);
  UserData.fromMap(dynamic obj) {
    email = obj['email'];
    majorSubjects = obj['majorSubjects'];
    degree = obj['degree'];
    location = obj['location'];
    phone = obj['phone'];
    userId = obj['userId'];
    username = obj['username'];
    type = obj['type'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['email'] = this.email;
      map['majorSubjects'] = this.majorSubjects;
      map['degree'] = this.degree;
      map['location'] = this.location;
      map['phone'] = this.phone;
      map['userId'] = this.userId;
      map['username'] = this.username;
      map['type'] = this.type;
    }
    return map;
  }
}
