class User {
  final String login;
  int position;

  User({
    required this.login,
    this.position = 0,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      login: map['login'],
      position: map['position'],
    );
  }
}
