import 'package:bloc/bloc.dart';
import 'package:client/main.dart';
import 'package:client/model/session.dart';
import 'package:client/service/remote_source.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final RemoteSource remoteSource = RemoteSourceImpl();

  LoginCubit() : super(const LoginState());

  void connectToServer(String login) async {
    if (login.isEmpty) {
      emit(state.copyWith(
        error: ErrorType.emptyLogin,
      ));
    } else {
      var sessions = await remoteSource.getActiveSessions();
      print('sessions(${sessions.length}): $sessions');
      emit(state.copyWith(
        isLoged: true,
        lobbySessions: sessions,
      ));
    }
  }
}
