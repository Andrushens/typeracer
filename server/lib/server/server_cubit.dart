import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:server/services/server.dart';

part 'server_state.dart';

class ServerCubit extends Cubit<ServerState> {
  ServerCubit() : super(ServerState());

  void startServer(String ip, String port) async {
    try {
      await state.server.startServer(ip, int.parse(port));
      emit(state.copyWith(
        isServerActive: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: ErrorType.socketException,
        errorMsg: e.toString(),
        isServerActive: false,
      ));
      emit(state.copyWith(
        error: ErrorType.none,
        errorMsg: '',
      ));
    }
  }
}
