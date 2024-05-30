import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shuchu/src/components/bottom_sheet.dart';
import 'package:shuchu/src/utils/parse_duration.dart';
import 'package:shuchu/src/utils/remap_num.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

enum TimerState { focus, rest }

class _MainAppState extends State<MainApp> {
  final ValueNotifier<bool> _isRunning = ValueNotifier(false);

  static Duration focusTime = const Duration(minutes: 10);
  static Duration breakTime = const Duration(minutes: 5);

  static Duration initialTime = focusTime;
  static const Duration addsubTime = Duration(minutes: 1);
  Duration variableTime = initialTime;

  TimerState timerState = TimerState.focus;

  late Timer timer;

  static int sessionCounter = 0;

  void toggleTimer() {
    _isRunning.value = !_isRunning.value;
    updateTimer();
  }

  void updateTimer() {
    if (_isRunning.value) {
      timer = Timer.periodic(Durations.extralong4, (Timer t) {
        if (variableTime.inSeconds > 0) {
          setState(() {
            variableTime -= Durations.extralong4;
          });
        } else {
          resetTimer();
          if (timerState == TimerState.focus) {
            sessionCounter++;
          }
          _showDialog();
        }
      });
    } else {
      timer.cancel();
    }
  }

  void resetTimer() {
    setState(() {
      variableTime = initialTime;
      timer.cancel();
      _isRunning.value = false;
    });
  }

  void resetSessionCount() {
    setState(() {
      sessionCounter = 0;
    });
  }

  void showResetSessionDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Session reset"),
            content: const Text(
                "You are about to reset the session count. Proceed?"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel")),
              FilledButton(
                  onPressed: () {
                    if (sessionCounter > 0) {
                      resetSessionCount();
                    }
                    Navigator.pop(context);
                  },
                  child: const Text("Ok")),
            ],
          );
        });
  }

  void addMinute() {
    setState(() {
      initialTime += addsubTime;
      variableTime += addsubTime;
    });
  }

  void subMinute() {
    if (initialTime.inSeconds > 60 && !_isRunning.value) {
      setState(() {
        initialTime -= addsubTime;
        variableTime -= addsubTime;
      });
    }
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        return const MenuBottomSheet();
      },
    );
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: timerState == TimerState.focus
                ? const Text("Take a break")
                : const Text("Resume work"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel")),
              FilledButton(
                  onPressed: () {
                    _dialogAction();
                    Navigator.pop(context);
                  },
                  child: const Text("Start")),
            ],
          );
        });
  }

  void _dialogAction() {
    if (timerState == TimerState.focus) {
      initialTime = breakTime;
      variableTime = initialTime;
      timerState = TimerState.rest;
    } else if (timerState == TimerState.rest) {
      initialTime = focusTime;
      variableTime = initialTime;
      timerState = TimerState.focus;
    }
    toggleTimer();
    setState(() {});
  }

  @override
  void initState() {
    Box userPrefs = Hive.box('user_prefs');
    super.initState();

    if (mounted) {
      WakelockPlus.toggle(
          enable: userPrefs.get('isWakeLock', defaultValue: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    double timerValue =
        variableTime.inSeconds.toDouble().remap(0, initialTime.inSeconds, 0, 1);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: timerValue,
              borderRadius: BorderRadius.circular(10),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: toggleTimer,
                      onDoubleTap: resetTimer,
                      onVerticalDragStart: (details) {
                        if (details.globalPosition.direction > 0) {
                          subMinute();
                        } else if (details.globalPosition.direction < 0) {
                          addMinute();
                        }
                      },
                      child: Text(
                        printDuration(variableTime),
                        style: const TextStyle(
                          fontFamily: 'IosevkaNerdFont',
                          fontWeight: FontWeight.normal,
                          fontSize: 70.0,
                        ),
                      ),
                    ),
                    timerState == TimerState.focus
                        ? Icon(
                            Icons.adjust_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : const Icon(
                            Icons.coffee_rounded,
                            color: Color(0xFF957FB8),
                          )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: _showBottomSheet,
                icon: const Icon(Icons.menu_rounded)),
            Row(
              children: [
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.label_rounded)),
                TextButton.icon(
                    icon: const Icon(Icons.hourglass_bottom_rounded),
                    onPressed: () {
                      if (sessionCounter > 0) {
                        showResetSessionDialog();
                      }
                    },
                    label: Text(
                      "$sessionCounter",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
