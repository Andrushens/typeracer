import 'dart:math';

import 'package:client/views/lobby/lobby_cubit.dart';
import 'package:client/views/lobby/widgets/session_container.dart';
import 'package:client/views/race/race.dart';
import 'package:client/views/race/race_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  late final TextEditingController loginController;

  @override
  void initState() {
    super.initState();
    loginController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LobbyCubit, LobbyState>(
      listener: (context, state) {
        var session = state.session;
        if (session != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return BlocProvider(
                  create: (context) => RaceCubit(session, state.user),
                  child: RaceScreen(
                    session: session,
                  ),
                );
              },
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 56,
                horizontal: 44,
              ),
              color: Colors.red.withOpacity(0.3),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Enter Any Race',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      MaterialButton(
                        onPressed: context.read<LobbyCubit>().fetchSessions,
                        color: Colors.blueAccent.withOpacity(.7),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        child: Text(
                          'Update Sessions',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                      MaterialButton(
                        onPressed: context.read<LobbyCubit>().createSession,
                        color: Colors.blueAccent.withOpacity(.7),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        child: Text(
                          'Create New',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.activeSessions.length,
                        itemBuilder: (context, index) {
                          var session = state.activeSessions[index];
                          return SessionContainer(
                            session: session,
                            onTap: () => context
                                .read<LobbyCubit>()
                                .connectToSession(session.id),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
