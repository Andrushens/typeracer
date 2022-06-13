class User {
  final String login;
  int position;

  User({
    required this.login,
    this.position = 0,
  });

  void updateTextIndex(int index) {
    position = index;
  }

  Map<String, dynamic> toMap() {
    return {
      '"login"': '"$login"',
      '"position"': position,
    };
  }
}
