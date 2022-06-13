import 'package:client/model/user.dart';
import 'package:flutter/material.dart';

class UserContainer extends StatelessWidget {
  const UserContainer({
    Key? key,
    required this.user,
    required this.textLength,
  }) : super(key: key);

  final User user;
  final int textLength;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 48 - 240;
    var position = (user.position / textLength * 100).ceil();
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 24,
      ),
      height: 130,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: Colors.yellow.withOpacity(0.3),
      ),
      child: Stack(
        children: [
          Text(
            'user ${user.login}',
            style: Theme.of(context).textTheme.headline6,
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: 30,
            left: position * width / 100,
            child: Image.asset(
              'images/lamba.png',
              width: 150,
            ),
          )
        ],
      ),
    );
  }
}
