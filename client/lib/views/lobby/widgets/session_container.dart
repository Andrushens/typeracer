import 'dart:async';

import 'package:client/model/session.dart';
import 'package:flutter/material.dart';

class SessionContainer extends StatefulWidget {
  const SessionContainer({
    Key? key,
    required this.session,
    required this.onTap,
  }) : super(key: key);

  final Session session;
  final VoidCallback onTap;

  @override
  State<SessionContainer> createState() => _SessionContainerState();
}

class _SessionContainerState extends State<SessionContainer> {
  late final Timer timer;
  late int secondsToStart;

  @override
  void initState() {
    super.initState();
    secondsToStart =
        (widget.session.expires - DateTime.now().millisecondsSinceEpoch) ~/
            1000;
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (secondsToStart == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            secondsToStart--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  bool isAvailable() => secondsToStart > 5;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isAvailable() ? widget.onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: isAvailable()
              ? Colors.yellow.withOpacity(0.3)
              : Colors.grey.withOpacity(0.4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'users: ${widget.session.users.length}',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              secondsToStart > 0
                  ? 'Starts in $secondsToStart'
                  : 'Race In Progress',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
