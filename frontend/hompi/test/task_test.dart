import 'package:flutter_test/flutter_test.dart';
import 'package:hompi/task.dart';

void main() {
  test('getIntervalInDays() should only display number of days', () {
    var task = new Task.dummy(title: "", interval: "2 00:00:00", dueDate: DateTime.now());
    expect(task.getIntervalInDays(), equals(2));
  });

  test('getIntervalInDays() should only return 0 for intervals shorter than one day', () {
    var task = new Task.dummy(title: "", interval: "05:05:05", dueDate: DateTime.now());
    expect(task.getIntervalInDays(), equals(0));
  });
}
