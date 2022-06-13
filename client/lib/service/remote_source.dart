import 'package:client/model/session.dart';
import 'package:client/model/user.dart';
import 'package:dio/dio.dart';

class RemoteSource {
  Future<List<Session>> getActiveSessions() => throw UnimplementedError();
  Future<Session> createSession(String login) => throw UnimplementedError();
  Future<Session> connectToSession(
    String id,
    String login,
  ) =>
      throw UnimplementedError();
  Future<int> updateSessionPosition(
    String userId,
    String sessionId,
    int position,
  ) =>
      throw UnimplementedError();
  Future<List<User>> getSessionPositions(
    String sessionId,
  ) =>
      throw UnimplementedError();
}

class RemoteSourceImpl implements RemoteSource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.100.6:38675',
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  @override
  Future<List<Session>> getActiveSessions() async {
    try {
      var response = await dio.get('/sessions');
      print('getActiveSessions status code ${response.statusCode}');
      var sessions = <Session>[];
      var data = response.data as List;
      for (var map in data) {
        sessions.add(Session.fromMap(map));
      }
      return sessions;
    } catch (e) {
      print('getActiveSessions failed: ${e.runtimeType}');
      rethrow;
    }
  }

  @override
  Future<Session> createSession(String login) async {
    try {
      var response = await dio.post('/sessions/create/$login');
      print('createSession status code ${response.statusCode}');
      return Session.fromMap(response.data);
    } catch (e) {
      print('createSession failed: ${e.runtimeType}');
      rethrow;
    }
  }

  @override
  Future<Session> connectToSession(String id, String login) async {
    try {
      var response = await dio.post('/sessions/connect/$id/$login');
      print('connectToSession status code ${response.statusCode}');
      return Session.fromMap(response.data);
    } catch (e) {
      print('connectToSession failed: ${e.runtimeType}');
      rethrow;
    }
  }

  @override
  Future<List<User>> getSessionPositions(String sessionId) async {
    try {
      var response = await dio.get('/sessions/$sessionId/positions');
      print('getSessionPositions status code ${response.statusCode}');
      var userMaps = response.data as List;
      var users = <User>[];
      for (var userMap in userMaps) {
        users.add(User.fromMap(userMap));
      }
      return users;
    } catch (e) {
      print('getSessionPositions failed: ${e.runtimeType}');
      rethrow;
    }
  }

  @override
  Future<int> updateSessionPosition(
    String userId,
    String sessionId,
    int position,
  ) async {
    try {
      var response = await dio.post(
        '/sessions/step/$sessionId/$userId/$position',
      );
      print('updateSessionPosition status code ${response.statusCode}');
      return response.data;
    } catch (e) {
      print('updateSessionPosition failed: ${e.runtimeType}');
      rethrow;
    }
  }
}
