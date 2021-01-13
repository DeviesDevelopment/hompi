class Task {
  int id;
  String title;
  DateTime dueDate;
  String interval;

  Task({this.id, this.title, this.dueDate, this.interval});

  Task.dummy({this.title, this.dueDate, this.interval});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      dueDate: DateTime.parse(json['due_date']),
      interval: json['interval'],
    );
  }

  int getIntervalInDays() {
    return int.parse(interval.split(" ")[0]);
  }
}
