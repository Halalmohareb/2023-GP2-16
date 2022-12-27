class Appointment {
  late String id;
  late String tutorId;
  late String tutorName;
  late String studentId;
  late String studentName;
  late String degree;
  late String lessonType;
  late String date;
  late List time;
  late String amount;
  late DateTime createdAt;
  late String status;
  late String paymentId;

  Appointment(
    this.id,
    this.tutorId,
    this.tutorName,
    this.studentId,
    this.studentName,
    this.degree,
    this.lessonType,
    this.date,
    this.time,
    this.amount,
    this.createdAt,
    this.status,
    this.paymentId,
  );
  Appointment.fromMap(dynamic obj) {
    tutorId = obj['tutorId'];
    tutorName = obj['tutorName'];
    studentId = obj['studentId'];
    studentName = obj['studentName'];
    degree = obj['degree'];
    lessonType = obj['lessonType'];
    date = obj['date'];
    time = obj['time'];
    amount = obj['amount'];
    createdAt = obj['createdAt'];
    status = obj['status'];
    paymentId = obj['paymentId'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['tutorId'] = this.tutorId;
    map['tutorName'] = this.tutorName;
    map['studentId'] = this.studentId;
    map['studentName'] = this.studentName;
    map['degree'] = this.degree;
    map['lessonType'] = this.lessonType;
    map['date'] = this.date;
    map['time'] = this.time;
    map['amount'] = this.amount;
    map['createdAt'] = this.createdAt;
    map['status'] = this.status;
    map['paymentId'] = this.paymentId;
    return map;
  }

}
