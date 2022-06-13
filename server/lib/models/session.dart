import 'package:server/models/user.dart';
import 'package:server/services/text_provider.dart';

class Session {
  final String id;
  final int expires; //timestamp
  final String text;
  List<User> users;

  Session({
    required this.id,
  })  : users = [],
        expires = DateTime.now().millisecondsSinceEpoch + 15000, 
        text = TextProvider.getRandomText();

  void addUser(String login) {
    users.add(User(login: login));
  }

  void updateUserTextPosition(String userId, int index) {
    var user = users.firstWhere((element) => element.login == userId);
    user.updateTextIndex(index);
  }

  Map<String, dynamic> toMap() {
    return {
      '"id"': '"$id"',
      '"text"': '"$text"',
      '"expires"': expires,
      '"users"': users.map((e) => '${e.toMap()}').toList(),
    };
  }

  @override
  String toString() {
    return '{id: $id, users: ${users.length} $users, expires: $expires}';
  }
}
