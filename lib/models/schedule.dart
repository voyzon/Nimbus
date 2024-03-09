import 'dart:convert';

class Schedule {
  String? scheduleId;
  String? taskId;
  List<DateTime>? repeatInterval;

  Schedule({
    this.scheduleId,
    this.taskId,
    this.repeatInterval,
  });

  Schedule copyWith({
    String? scheduleId,
    String? taskId,
    List<DateTime>? repeatInterval,
  }) =>
      Schedule(
        scheduleId: scheduleId ?? this.scheduleId,
        taskId: taskId ?? this.taskId,
        repeatInterval: repeatInterval ?? this.repeatInterval,
      );

  factory Schedule.fromRawJson(String str) =>
      Schedule.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        scheduleId: json["scheduleId"],
        taskId: json["taskId"],
        repeatInterval: json["repeatInterval"] == null
            ? []
            : List<DateTime>.from(
                json["repeatInterval"]!.map((x) => DateTime.parse(x))),
      );

  Map<String, dynamic> toJson() => {
        "scheduleId": scheduleId,
        "taskId": taskId,
        "repeatInterval": repeatInterval == null
            ? []
            : List<dynamic>.from(
                repeatInterval!.map((x) => x.toIso8601String())),
      };
}
