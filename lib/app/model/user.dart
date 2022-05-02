import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// username : "alex"
/// admin : true
/// token : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MjU2OTVjNzMyODFmN2RiYjFkYTQ2OTYiLCJ1c2VybmFtZSI6ImFsZXgiLCJwYXNzd29yZCI6IiQyYiQxMCQuM3ZWT3NNbG1sSHZBVFh2MnlMcDcuSGlXbXFrZlBnYm5ON3JobjcvV0dwNXBmUm8yUWRTcSIsImFkbWluIjp0cnVlLCJvcmdhbml6YXRpb25JRCI6IjYyNTY4OWYxYmM1YmI2YjJjZGQ3OTBjZiIsIl9fdiI6MCwiaWF0IjoxNjUwODIyODEwfQ.cdSecU5hf_9T5ZZmyQ-siUYUB-WCRkE6AUUEmPwzSlo"
/// id : "625695c73281f7dbb1da4696"

class User extends Equatable {
  const User({
    required this.id,
    this.admin = false,
    required this.username,
    required this.token,
    required this.organizationID,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        admin: json['admin'] as bool,
        token: json['token'] as String,
        username: json['username'] as String,
        organizationID: json['organizationID'] as String,
      );
  final String id;
  final bool admin;
  final String username;
  final String token;
  final String organizationID;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'username': username,
        'admin': admin,
        'token': token,
        'organizationID': organizationID
      };

  @override
  List<Object?> get props => [id, username, admin, token];

  static const empty = User(
    id: '',
    username: '',
    token: '',
    organizationID: '',
  );

  static Future<User> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final extractedUserData =
        jsonDecode(prefs.get('user').toString()) as Map<String, dynamic>;
    return User.fromJson(extractedUserData);
  }
}
