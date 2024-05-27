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

class _MainAppState extends State<MainApp> {
  final ValueNotifier<bool> _isRunning = ValueNotifier(false);

  static Duration initialTime = const Duration(minutes: 25);
  static const Duration addsubTime = Duration(minutes: 1);
  Duration variableTime = initialTime;

  late Timer timer;
  void _toggleTimer() {
    _isRunning.value = !_isRunning.value;
    if (_isRunning.value) {
      updateTime();
    } else {
      timer.cancel();
    }
  }

  void updateTime() {
    timer = Timer.periodic(Durations.extralong4, (Timer t) {
      if (variableTime.inSeconds > 0) {
        setState(() {
          variableTime -= Durations.extralong4;
        });
      }
    });
  }

  void resetTimer() {
    setState(() {
      variableTime = initialTime;
    });
    timer.cancel();
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
              child: Container(
                color: Colors.red,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (!_isRunning.value)
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.remove_rounded),
                        color: Colors.amber,
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                Colors.amberAccent)),
                      ),
                    GestureDetector(
                      onTap: _toggleTimer,
                      onDoubleTap: resetTimer,
                      onVerticalDragStart: (details) {
                        if (details.globalPosition.direction > 0) {
                          subMinute();
                        } else if (details.globalPosition.direction < 0) {
                          addMinute();
                        }
                        log("${details.globalPosition.direction - details.localPosition.direction}");
                      },
                      child: SizedBox(
                        child: Text(
                          printDuration(variableTime),
                          style: const TextStyle(
                            fontFamily: 'IosevkaNerdFont',
                            fontWeight: FontWeight.normal,
                            fontSize: 70.0,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.amber)),
                      child: const Icon(Icons.add_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
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
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.delete_rounded,
                      color: Color(0xFFFF5D62),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
