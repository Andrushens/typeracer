import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:server/server/server_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServerCubit(),
      child: MaterialApp(
        title: 'Server App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(title: 'My Awesome Server'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController hostController = TextEditingController()
    ..text = '192.168.100.6';
  final TextEditingController portController = TextEditingController()
    ..text = '38675';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ServerCubit, ServerState>(
      listener: (context, state) {
        if (state.error == ErrorType.socketException) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Socket Exception',
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      state.errorMsg,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: hostController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: portController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: state.isServerActive
                      ? null
                      : () {
                          context.read<ServerCubit>().startServer(
                                hostController.text,
                                portController.text,
                              );
                        },
                  child: Text(
                    state.isServerActive ? 'Server is Up' : 'Start Server',
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
