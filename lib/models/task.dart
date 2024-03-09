import 'dart:convert';

class Task {
  String? taskId;
  String? uid;
  String? title;
  String? description;
  DateTime? dueDate;
  DateTime? createdAt;
  List<DateTime>? reminderTime;
  bool? urgent;
  bool? important;
  bool? isActive;
  TypeOfTask? typeOfTask;

  Task({
    this.taskId,
    this.uid,
    this.title,
    this.description,
    this.dueDate,
    this.createdAt,
    this.reminderTime,
    this.urgent,
    this.important,
    this.isActive,
    this.typeOfTask,
  });

  Task copyWith({
    String? taskId,
    String? uid,
    String? title,
    String? description,
    DateTime? dueDate,
    DateTime? createdAt,
    List<DateTime>? reminderTime,
    bool? urgent,
    bool? important,
    bool? isActive,
    TypeOfTask? typeOfTask,
  }) =>
      Task(
        taskId: taskId ?? this.taskId,
        uid: uid ?? this.uid,
        title: title ?? this.title,
        description: description ?? this.description,
        dueDate: dueDate ?? this.dueDate,
        createdAt: createdAt ?? this.createdAt,
        reminderTime: reminderTime ?? this.reminderTime,
        urgent: urgent ?? this.urgent,
        important: important ?? this.important,
        isActive: isActive ?? this.isActive,
        typeOfTask: typeOfTask ?? this.typeOfTask,
      );

  factory Task.fromRawJson(String str) => Task.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        taskId: json["taskId"],
        uid: json["uid"],
        title: json["title"],
        description: json["description"],
        dueDate:
            json["dueDate"] == null ? null : DateTime.parse(json["dueDate"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        reminderTime: json["reminderTime"] == null
            ? []
            : List<DateTime>.from(
                json["reminderTime"]!.map((x) => DateTime.parse(x))),
        urgent: json["urgent"],
        important: json["important"],
        isActive: json["isActive"],
        typeOfTask: typeOfTaskValues.map[json["typeOfTask"]]!,
      );

  Map<String, dynamic> toJson() => {
        "taskId": taskId,
        "uid": uid,
        "title": title,
        "description": description,
        "dueDate": dueDate?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "reminderTime": reminderTime == null
            ? []
            : List<dynamic>.from(reminderTime!.map((x) => x.toIso8601String())),
        "urgent": urgent,
        "important": important,
        "isActive": isActive,
        "typeOfTask": typeOfTaskValues.reverse[typeOfTask],
      };
}

enum TypeOfTask { ACTIVE, INACTIVE }

final typeOfTaskValues =
    EnumValues({"active": TypeOfTask.ACTIVE, "inactive": TypeOfTask.INACTIVE});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}