import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:client/model/session.dart';
import 'package:client/model/user.dart';
import 'package:client/service/remote_source.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'race_state.dart';

class RaceCubit extends Cubit<RaceState> {
  final RemoteSource remoteSource = RemoteSourceImpl();

  RaceCubit(
    Session session,
    User user,
  ) : super(RaceState(
          session: session,
          user: user,
          users: session.users,
        ));

  void onTextChanged(TextEditingController controller) {
    var currentText = controller.text;
    if (currentText.isEmpty) return;
    var symb = currentText[currentText.length - 1];
    if (symb != state.text[state.currentTextIndex]) {
      emit(state.copyWith(isWrongSymbol: true));
    } else {
      if (currentText.endsWith(' ')) {
        controller.text = '';
      }
      if (state.currentTextIndex == state.text.length - 1) {
        emit(state.copyWith(isFinish: true));
        updatePosition(state.text.length - 1);
      } else {
        emit(state.copyWith(
          currentTextIndex: state.currentTextIndex + 1,
        ));
        var diff = state.currentTextIndex - state.lastUpdateTextIndex;
        if (diff / state.text.length > 0.04) {
          updatePosition(state.currentTextIndex);
          emit(state.copyWith(lastUpdateTextIndex: state.currentTextIndex));
        }
      }
    }
  }

  void updateTypeSpeed(int timeSpend) {
    if (timeSpend == 0 || state.isFinish) {
      return;
    }
    var typeSpeed = (state.currentTextIndex * 60 / timeSpend).ceil();
    emit(state.copyWith(typeSpeed: typeSpeed));
  }

  Future<void> updatePosition(int position) async {
    await remoteSource.updateSessionPosition(
      state.user.login,
      state.session.id,
      position,
    );
  }

  Future<void> updateSessionUsers() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      var users = await remoteSource.getSessionPositions(state.session.id);
      emit(state.copyWith(users: users));
      if (!state.isFinish) {
        updateSessionUsers();
      }
    } catch (_) {}
  }

  void stop() {
    emit(state.copyWith(isFinish: true));
  }
}
