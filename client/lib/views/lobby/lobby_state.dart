part of 'lobby_cubit.dart';

class LobbyState extends Equatable {
  final User user;
  final Session? session;
  final List<Session> activeSessions;

  const LobbyState({
    required this.user,
    required this.activeSessions,
    this.session,
  });

  LobbyState copyWith({
    Session? session,
    List<Session>? activeSessions,
  }) {
    return LobbyState(
      user: user,
      session: session,
      activeSessions: activeSessions ?? this.activeSessions,
    );
  }

  @override
  List<Object?> get props => [session, activeSessions];
}
