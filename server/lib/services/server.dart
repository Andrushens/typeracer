import 'dart:io';

import 'package:server/models/session.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:uuid/uuid.dart';

class Server {
  final defaultHeaders = {'Content-Type': 'application/json'};

  List<Session> sessions = [];

  late final router = Router()
    ..get('/sessions', getSessionsHandler)
    ..post('/sessions/create/<userId>', createSessionHandler)
    ..post('/sessions/connect/<sessionId>/<userId>', connectSessionHandler)
    ..post(
      '/sessions/step/<sessionId>/<userId>/<position>',
      updatePositionHandler,
    )
    ..get(
      '/sessions/<sessionId>/positions',
      getPositionsHandler,
    );

  Response getSessionsHandler(Request request) {
    try {
      sessions.removeWhere(
        (e) => e.expires + 100000 < DateTime.now().millisecondsSinceEpoch,
      );
    } catch (_) {
    }
    return Response.ok(
      sessions
          .map(
            (e) => e.toMap(),
          )
          .toList()
          .toString(),
      headers: defaultHeaders,
    );
  }

  Future<Response> createSessionHandler(Request request) async {
    var userId = request.params['userId']!;
    var sessionId = const Uuid().v1();
    var session = Session(id: sessionId);
    session.addUser(userId);
    sessions.add(session);
    return Response.ok(
      session.toMap().toString(),
      headers: defaultHeaders,
    );
  }

  Response connectSessionHandler(Request request) {
    try {
      var sessionId = request.params['sessionId'];
      var userId = request.params['userId']!;
      var session = sessions.firstWhere((element) => element.id == sessionId);
      session.addUser(userId);
      return Response.ok(
        session.toMap().toString(),
        headers: defaultHeaders,
      );
    } catch (e) {
      return Response.notFound(
        {'"error"': '"404"'}.toString(),
        headers: defaultHeaders,
      );
    }
  }

  Response updatePositionHandler(Request request) {
    try {
      var sessionId = request.params['sessionId'];
      var userId = request.params['userId']!;
      var currentIndex = int.parse(request.params['position']!);
      var session = sessions.firstWhere((element) => element.id == sessionId);
      session.updateUserTextPosition(userId, currentIndex);
      return Response.ok(
        '$currentIndex',
        headers: defaultHeaders,
      );
    } catch (e) {
      print(e);
      return Response.notFound(
        {'"error"': '"404"'}.toString(),
        headers: defaultHeaders,
      );
    }
  }

  Response getPositionsHandler(Request request) {
    try {
      var sessionId = request.params['sessionId'];
      for (var s in sessions) {
        print(s.id);
      }
      print(sessionId);
      var session = sessions.firstWhere((element) => element.id == sessionId);
      var users = session.users;
      return Response.ok(
        users
            .map(
              (e) => e.toMap(),
            )
            .toList()
            .toString(),
        headers: defaultHeaders,
      );
    } catch (e) {
      print(e);
      return Response.notFound(
        {'"error"': '"404"'}.toString(),
        headers: defaultHeaders,
      );
    }
  }

  Future<void> startServer(String address, int port) async {
    var ip = InternetAddress(address);
    var handler = const Pipeline()
        .addMiddleware(
          logRequests(),
        )
        .addHandler(router);
    try {
      final server = await serve(handler, ip, port);
      print('Server listening on port ${server.port}');
    } catch (e) {
      rethrow;
    }
  }
}
