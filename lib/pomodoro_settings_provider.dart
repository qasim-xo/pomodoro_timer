import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_timer/pomodoro_timer_provider.dart';


class PomodoroSettingsState {
  Duration focusSession;
  Duration shortBreak;
  Duration longBreak;
  int longBreakInterval;

  PomodoroSettingsState({
    required this.focusSession,
    required this.shortBreak,
    required this.longBreak,
    required this.longBreakInterval,
  });

  PomodoroSettingsState copyWith({
    Duration? focusSession,
    Duration? shortBreak,
    Duration? longBreak,
    int? longBreakInterval,
  }) {
    return PomodoroSettingsState(
      focusSession: focusSession ?? this.focusSession,
      shortBreak: shortBreak ?? this.shortBreak,
      longBreak: longBreak ?? this.longBreak,
      longBreakInterval: longBreakInterval ?? this.longBreakInterval,
    );
  }

  factory PomodoroSettingsState.initial() {
    return PomodoroSettingsState(
      focusSession: const Duration(minutes: 25, seconds: 0),
      shortBreak: const Duration(minutes: 5),
      longBreak: const Duration(minutes: 15),
      longBreakInterval: 4,
    );
  }
}

class PomodoroSettingsNotifier extends Notifier<PomodoroSettingsState> {
  @override
  PomodoroSettingsState build() {
    print("PomodoroSettingsProvider is being rebuilt");
    return PomodoroSettingsState.initial();
  }

  void setFocusSession(Duration newFocusSession) {
    debugPrint('setFocusSession $newFocusSession');
    state = state.copyWith(focusSession: newFocusSession);

    final isRunning = ref.read(pomodoroTimerProvider).isRunning;
    final isBreak = ref.read(pomodoroTimerProvider).isBreak;

    
      ref.read(pomodoroTimerProvider.notifier).setTime(newFocusSession);
    
  }

  void setShortBreak(Duration newShortBreak) {
    final isBreak = ref.read(pomodoroTimerProvider).isBreak;

    
    state = state.copyWith(shortBreak: newShortBreak);
  }

  void setLongBreak(Duration newLongBreak) {
    state = state.copyWith(longBreak: newLongBreak);
  }

  void setLongBreakInterval(int newLongBreakInterval) {
    state = state.copyWith(longBreakInterval: newLongBreakInterval);
  }
}

final pomodoroSettingsProvider =
    NotifierProvider<PomodoroSettingsNotifier, PomodoroSettingsState>(
   PomodoroSettingsNotifier.new
);
