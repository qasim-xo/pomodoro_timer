import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_timer/pomodoro_settings_sheet_widget.dart';
import 'package:pomodoro_timer/pomodoro_timer_provider.dart';
import 'package:pomodoro_timer/pomodoro_timer_widget.dart';

class PomodoroScreen extends ConsumerStatefulWidget {
  const PomodoroScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends ConsumerState<PomodoroScreen> {

  @override
  Widget build(BuildContext context) {
    final isRunning = ref.watch(pomodoroTimerProvider).isRunning; 
    return Column(
      children: [
        const PomodoroTimerWidget(),
        const PomodoroSettingsSheetWidget(),
         ElevatedButton(onPressed: isRunning == false ? () {
                    ref.read(pomodoroTimerProvider.notifier).startTimer(); 
                  } : () {
                    ref.read(pomodoroTimerProvider.notifier).pauseTimer();
                  }
                  
                  , child: isRunning ? Text('Pause') : Text('Start'))
      ],
    );
  }
}