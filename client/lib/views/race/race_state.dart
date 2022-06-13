part of 'race_cubit.dart';

class RaceState extends Equatable {
  final User user;
  final Session session;
  final String text;
  final int currentTextIndex;
  final int lastUpdateTextIndex;
  final int typeSpeed;
  final bool isWrongSymbol;
  final bool isFinish;
  final List<User> users;

  RaceState({
    required this.session,
    required this.user,
    required this.users,
    this.currentTextIndex = 0,
    this.lastUpdateTextIndex = 0,
    this.typeSpeed = 0,
    this.isWrongSymbol = false,
    this.isFinish = false,
  }) : text = session.text;

  RaceState copyWith({
    int? currentTextIndex,
    int? lastUpdateTextIndex,
    int? typeSpeed,
    bool? isWrongSymbol,
    bool? isFinish,
    List<User>? users,
  }) {
    return RaceState(
      user: user,
      session: session,
      users: users ?? this.users,
      currentTextIndex: currentTextIndex ?? this.currentTextIndex,
      lastUpdateTextIndex: lastUpdateTextIndex ?? this.lastUpdateTextIndex,
      typeSpeed: typeSpeed ?? this.typeSpeed,
      isWrongSymbol: isWrongSymbol ?? false,
      isFinish: isFinish ?? this.isFinish,
    );
  }

  @override
  List<Object?> get props {
    return [
      session,
      user,
      text,
      currentTextIndex,
      isWrongSymbol,
      isFinish,
      typeSpeed,
      lastUpdateTextIndex,
      users,
    ];
  }
}
