import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shuchu/src/components/bottom_sheet.dart';
import 'package:shuchu/src/utils/parse_duration.dart';
import 'package:shuchu/src/utils/remap_num.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

enum TimerState { focus, rest }

class _MainAppState extends State<MainApp> {
  final ValueNotifier<bool> _isRunning = ValueNotifier(false);

  static Duration focusTime = const Duration(seconds: 10);
  static Duration breakTime = const Duration(seconds: 5);

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
          log("${timer.isActive}");
        } else {
          setState(() {
            resetTimer();
            sessionCounter++;
          });
          _showDialog();
        }
      });
    } else {
      timer.cancel();
    }
  }

  void resetTimer() {
    variableTime = initialTime;
    timer.cancel();
    _isRunning.value = false;
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
      log("${_isRunning.value}");
    } else if (timerState == TimerState.rest) {
      initialTime = focusTime;
      variableTime = initialTime;
      timerState = TimerState.focus;
    }
    toggleTimer();
    setState(() {});
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
                      setState(() {
                        sessionCounter++;
                      });
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
