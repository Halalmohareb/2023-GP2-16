class BookedLesson {
  late String id;
  late String studentMail;
  late String studentName;
  late String tutorMail;
  late String tutorName;
  late String subject;
  late DateTime time;
  late String level;
  late String status;

  BookedLesson(this.id, this.studentMail, this.studentName, this.tutorMail,
      this.tutorName, this.subject, this.time, this.level, this.status);
  BookedLesson.fromMap(dynamic obj) {
    studentMail = obj['studentMail'];
    studentName = obj['studentName'];
    tutorName = obj['tutorName'];
    tutorMail = obj['tutorMail'];
    subject = obj['subject'];
    level = obj['level'];
    time = obj['time'].toDate();
    status = obj['status'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['studentMail'] = this.studentMail;
      map['studentName'] = this.studentName;
      map['tutorName'] = this.tutorName;
      map['tutorMail'] = this.tutorMail;
      map['subject'] = this.subject;
      map['level'] = this.level;
      map['time'] = this.time;
      map['status'] = this.status;
    }
    return map;
  }
}
