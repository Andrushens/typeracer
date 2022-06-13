part of 'login_cubit.dart';

enum ErrorType { none, socketException, emptyLogin }

class LoginState extends Equatable {
  final ErrorType error;
  final List<Session> lobbySessions;
  final bool isLoged;

  const LoginState({
    this.error = ErrorType.none,
    this.isLoged = false,
    this.lobbySessions = const [],
  });

  LoginState copyWith({
    ErrorType? error,
    List<Session>? lobbySessions,
    bool? isLoged,
  }) {
    return LoginState(
      error: error ?? this.error,
      lobbySessions: lobbySessions ?? this.lobbySessions,
      isLoged: isLoged ?? this.isLoged,
    );
  }

  @override
  List<Object?> get props => [error, lobbySessions, isLoged];
}
