part of 'server_cubit.dart';

enum ErrorType { none, socketException }

class ServerState extends Equatable {
  final Server server;
  final ErrorType error;
  final String errorMsg;
  final bool isServerActive;

  ServerState({
    this.error = ErrorType.none,
    this.errorMsg = '',
    this.isServerActive = false,
  }) : server = Server();

  ServerState copyWith({
    ErrorType? error,
    String? errorMsg,
    bool? isServerActive,
  }) {
    return ServerState(
      error: error ?? this.error,
      errorMsg: errorMsg ?? this.errorMsg,
      isServerActive: isServerActive ?? this.isServerActive,
    );
  }

  @override
  List<Object?> get props => [error, errorMsg, isServerActive];
}
