import 'package:bloc/bloc.dart';
import 'package:client/model/session.dart';
import 'package:client/model/user.dart';
import 'package:client/service/remote_source.dart';
import 'package:equatable/equatable.dart';

part 'lobby_state.dart';

class LobbyCubit extends Cubit<LobbyState> {
  final RemoteSource remoteSource = RemoteSourceImpl();

  LobbyCubit(User user, List<Session> sessions)
      : super(LobbyState(
          user: user,
          activeSessions: sessions,
        ));

  void createSession() async {
    try {
      var session = await remoteSource.createSession(state.user.login);
      emit(
        state.copyWith(session: session),
      );
    } catch (e) {
      print(e.runtimeType);
    }
  }

  Future<void> fetchSessions() async {
    var sessions = await remoteSource.getActiveSessions();
    emit(state.copyWith(activeSessions: sessions));
  }

  Future<void> connectToSession(String id) async {
    try {
      var session = await remoteSource.connectToSession(id, state.user.login);
      emit(
        state.copyWith(session: session),
      );
    } catch (e) {
      rethrow;
    }
  }
}
