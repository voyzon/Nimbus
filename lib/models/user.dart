import 'dart:convert';

class User {
  String uid;
  String username;
  String email;
  DateTime createdAt;
  int dailyLimit;

  User({
    required this.uid,
    required this.username,
    required this.email,
    required this.createdAt,
    required this.dailyLimit,
  });

  User copyWith({
    String? uid,
    String? username,
    String? email,
    DateTime? createdAt,
    int? dailyLimit,
  }) =>
      User(
        uid: uid ?? this.uid,
        username: username ?? this.username,
        email: email ?? this.email,
        createdAt: createdAt ?? this.createdAt,
        dailyLimit: dailyLimit ?? this.dailyLimit,
      );

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        uid: json["uid"],
        username: json["username"],
        email: json["email"],
        createdAt: DateTime.parse(json["createdAt"]),
        dailyLimit: json["dailyLimit"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "email": email,
        "createdAt": createdAt.toIso8601String(),
        "dailyLimit": dailyLimit,
      };
}
