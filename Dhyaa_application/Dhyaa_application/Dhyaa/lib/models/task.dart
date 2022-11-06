class Task {
  late String id = '';
  late int isCompleted = 0;
  late String date = '';
  late String startTime = '';
  late String endTime = '';
  late int color = 0;
  late String day = '';

  Task(
    this.id,
    this.isCompleted,
    this.date,
    this.startTime,
    this.endTime,
    this.color,
    this.day,
  );

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isCompleted = json['isCompleted'];
    date = '';
    startTime = json['startTime'];
    endTime = json['endTime'];
    color = json['color'];
    day = json['day'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    //data['title'] = title;
    // data['date'] = this.date;
    // data['note'] = this.note;
    data['isCompleted'] = isCompleted;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['color'] = color;
    // data['remind'] = this.remind;
    data['day'] = day;
    return data;
  }
}
