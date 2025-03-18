import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_timer/pomodoro_settings_provider.dart';

class PomodoroTimerState {
  bool isRunning;
  bool isBreak;
  DateTime pausedTime;
  Timer? timer;
  Duration? time;

  PomodoroTimerState(
      {required this.isRunning,
      required this.pausedTime,
      required this.timer,
      required this.time,
      required this.isBreak});

  PomodoroTimerState copyWith(
      {bool? isRunning,
      Timer? timer,
      Duration? time,
      bool? isBreak,
      DateTime? pausedTime}) {
    return PomodoroTimerState(
        isRunning: isRunning ?? this.isRunning,
        timer: timer ?? this.timer,
        time: time ?? this.time,
        isBreak: isBreak ?? this.isBreak,
        pausedTime: pausedTime ?? this.pausedTime);
  }

  factory PomodoroTimerState.initial() {
    return PomodoroTimerState(
        pausedTime: DateTime.now(),
        isRunning: false,
        timer: null,
        time: const Duration(minutes: 25, seconds: 0),
        isBreak: false);
  }
}

class PomodoroTimerNotifier extends Notifier<PomodoroTimerState> {
  @override
  PomodoroTimerState build() {
    return PomodoroTimerState.initial();
  }

  void setIsRunning(bool newIsRunning) {
    state = state.copyWith(isRunning: newIsRunning);
  }

  void setTime(Duration newTime) {
    state = state.copyWith(time: newTime);
  }

  void startTimer() {
    state = state.copyWith(isRunning: true);
    final focusSession = ref.read(pomodoroSettingsProvider).focusSession;
    final shortBreak = ref.read(pomodoroSettingsProvider).shortBreak;
    debugPrint('SB : $shortBreak');
    state.timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(time: state.time! - const Duration(seconds: 1));

      int minutes = state.time!.inMinutes;
      int seconds = state.time!.inSeconds % 60;

      if (minutes <= 0 && seconds <= 0) {
        state = state.copyWith(isRunning: false);
        timer.cancel();

        if (state.isBreak) {
          state = state.copyWith(isBreak: false);
          setTime(focusSession);
        } else {
          state = state.copyWith(isBreak: true);
          setTime(shortBreak);
        }

        // setTime(ref.read(pomodoroSettingsProvider).shortBreak);
      }
    });
  }

  void resume() {
    if (remainingSeconds() > 0) {
      state = state.copyWith(time: Duration(seconds: remainingSeconds()));
      startTimer();
    }
  }

  void setPausedTime(int inSeconds) {
    final dateTimeNow = DateTime.now();
    state = state.copyWith(
        pausedTime: dateTimeNow.add(Duration(seconds: inSeconds)));
  }

  int remainingSeconds() {
    final dateTimeNow = DateTime.now();
    final remainingTime = state.pausedTime.difference(dateTimeNow);
    return remainingTime.inSeconds;
  }

  void pauseTimer() {
    state = state.copyWith(isRunning: false);
    setPausedTime(state.time!.inSeconds);
    state.timer!.cancel();
  }
}

final pomodoroTimerProvider =
    NotifierProvider<PomodoroTimerNotifier, PomodoroTimerState>(
        PomodoroTimerNotifier.new);
