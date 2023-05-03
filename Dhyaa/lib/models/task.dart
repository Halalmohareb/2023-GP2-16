class Task {
  late String id = '';
  late String date = '';
  late String startTime = '';
  late String endTime = '';
  late String day = '';

  Task(
    this.id,
    this.date,
    this.startTime,
    this.endTime,
    this.day,
  );

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = '';
    startTime = json['startTime'];
    endTime = json['endTime'];
    day = json['day'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    //data['title'] = title;
    // data['date'] = this.date;
    // data['note'] = this.note;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    // data['remind'] = this.remind;
    data['day'] = day;
    return data;
  }
}
