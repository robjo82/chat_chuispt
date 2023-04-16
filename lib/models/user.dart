import 'package:flutter/foundation.dart';

class LocalUser {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime firstConnection;
  final DateTime lastConnection;

  LocalUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.firstConnection,
    required this.lastConnection,
  });

  static LocalUser fromMap(Map<String, dynamic> map, String id) {
    if (kDebugMode) {
      print("voici le user reçu $map");
    }

    return LocalUser(
      id: id,
      firstName: map['first_name'],
      lastName: map['last_name'],
      firstConnection: DateTime.parse(map['first_connection']),
      lastConnection: DateTime.parse(map['last_connection']),
    );
  }
}
