import 'package:client/model/user.dart';

class Session {
  final String id;
  final int expires; //timestamp
  List<User> users;
  final String text;

  Session({
    required this.users,
    required this.id,
    required this.expires,
    required this.text,
  });

  void addUser(User user) {
    users.add(user);
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    var userMaps = map['users'] as List;
    var users = <User>[];
    for (var userMap in userMaps) {
      users.add(User.fromMap(userMap));
    }
    return Session(
      users: users,
      id: map['id'],
      expires: map['expires'],
      text: map['text'],
    );
  }

  @override
  String toString() {
    return 'id: $id, users: ${users.length}, expires: $expires';
  }
}
