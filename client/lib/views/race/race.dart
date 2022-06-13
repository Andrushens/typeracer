import 'dart:async';

import 'package:client/model/session.dart';
import 'package:client/views/race/race_cubit.dart';
import 'package:client/views/race/widgets/highlighted_text.dart';
import 'package:client/views/race/widgets/user_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RaceScreen extends StatefulWidget {
  final Session session;

  const RaceScreen({
    required this.session,
    Key? key,
  }) : super(key: key);

  @override
  State<RaceScreen> createState() => _RaceScreenState();
}

class _RaceScreenState extends State<RaceScreen> {
  late final FocusNode textFieldFocus;
  late final TextEditingController textController;
  late final Timer timer;
  late int secondsToStart;

  @override
  void initState() {
    super.initState();
    textFieldFocus = FocusNode();
    textController = TextEditingController();
    secondsToStart =
        (widget.session.expires - DateTime.now().millisecondsSinceEpoch) ~/
            1000;
    context.read<RaceCubit>().updateSessionUsers();
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (secondsToStart == 0) {
          FocusScope.of(context).requestFocus(textFieldFocus);
        }

        if (secondsToStart <= 0) {
          setState(() {
            context.read<RaceCubit>().updateTypeSpeed(secondsToStart.abs());
            secondsToStart--;
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
    textController.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RaceCubit, RaceState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () {
            context.read<RaceCubit>().stop();
            return Future.value(true);
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.yellow.withOpacity(.3),
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 22,
                horizontal: 44,
              ),
              color: Colors.red.withOpacity(0.3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Total Users: ${state.users.length}',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Text(
                        secondsToStart > 0
                            ? 'Starts in $secondsToStart'
                            : '${state.typeSpeed} symbols/min',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 24,
                            horizontal: 24,
                          ),
                          width: double.maxFinite,
                          color: Colors.yellow.withOpacity(0.3),
                          child: secondsToStart < 4
                              ? HighlightedSymbolText(
                                  text: widget.session.text,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      ?.copyWith(
                                          color: state.isFinish
                                              ? Colors.black.withOpacity(.4)
                                              : null),
                                  index: state.currentTextIndex,
                                  highlightColor: state.isWrongSymbol
                                      ? Colors.red
                                      : Colors.blue,
                                )
                              : Text(
                                  'Text will show in ${secondsToStart - 4}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      ?.copyWith(
                                        color: Colors.black.withOpacity(.4),
                                      ),
                                ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: TextField(
                      controller: textController,
                      focusNode: textFieldFocus,
                      enabled: !state.isFinish && secondsToStart <= 0,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: state.isWrongSymbol
                                ? Colors.red
                                : state.isFinish
                                    ? Colors.grey
                                    : null,
                          ),
                      onChanged: (val) {
                        context.read<RaceCubit>().onTextChanged(textController);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.users.length,
                        itemBuilder: (context, index) {
                          var user = state.users[index];
                          return UserContainer(
                            user: user,
                            textLength: state.text.length,
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
