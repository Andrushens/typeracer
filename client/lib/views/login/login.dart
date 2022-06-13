import 'package:client/model/user.dart';
import 'package:client/views/lobby/lobby.dart';
import 'package:client/views/lobby/lobby_cubit.dart';
import 'package:client/views/login/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController loginController;

  @override
  void initState() {
    super.initState();
    loginController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.error == ErrorType.emptyLogin) {
          print('error: empty login');
          //TODO shake
        }
        if (state.isLoged) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return BlocProvider(
                  create: (context) => LobbyCubit(
                    User(
                      login: loginController.text,
                    ),
                    state.lobbySessions,
                  ),
                  child: const LobbyScreen(),
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
                  Text(
                    'Login To Start Race',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: size.width * 0.2,
                    child: TextField(
                      controller: loginController,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline5,
                      decoration: const InputDecoration(
                        hintText: 'John Doe',
                      ),
                    ),
                  ),
                  const SizedBox(height: 34),
                  MaterialButton(
                    onPressed: () {
                      context
                          .read<LoginCubit>()
                          .connectToServer(loginController.text);
                    },
                    color: Colors.blueAccent.withOpacity(.7),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    child: Text(
                      'Login',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(color: Colors.white),
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
