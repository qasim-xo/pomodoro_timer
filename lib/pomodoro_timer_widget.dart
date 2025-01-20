import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_timer/pomodoro_settings_provider.dart';
import 'package:pomodoro_timer/pomodoro_timer_provider.dart';


class PomodoroTimerWidget extends ConsumerWidget {
  const PomodoroTimerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
   
    final isBreak = ref.watch(pomodoroTimerProvider).isBreak;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 200.0,
          child: Stack(
            children: <Widget>[
              const Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    strokeWidth: 10,
                    value: 0.5,
                  ),
                ),
              ),
              Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Consumer(
                    builder:
                        (BuildContext context, WidgetRef ref, Widget? child) {
                        
                      final time = ref.watch(pomodoroTimerProvider).time;
                       final shortBreak = ref.watch(pomodoroSettingsProvider).shortBreak;

                      print("Time : $time Short Break : $shortBreak");

                      final timeInMinutes = time?.inMinutes;
                      final timeInSeconds = time!.inSeconds % 60;

                      return Text("$timeInMinutes:$timeInSeconds",
                              );
                    },
                  ),
                  isBreak == true ? Text("Break") : Text("Focus",),
                ],
              )),
            ],
          ),
        ),
      ],
    );
  }
}
