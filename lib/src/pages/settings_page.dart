import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double borderRadius = 10.0;
  ShapeBorder shapeBorder =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0));

  Box userPrefsBox = Hive.box('user_prefs');

  late bool isDarkMode;
  late bool isWakeLock;

  late int sessionDuration =
      userPrefsBox.get('sessionDuration', defaultValue: 25.0);
  late int breakDuration = userPrefsBox.get('breakDuration', defaultValue: 5.0);

  void onDarkMode(bool? on) async {
    setState(() {
      isDarkMode = on!;
      userPrefsBox.put('isDarkMode', on);
    });
  }

  void onWakeLock(bool? on) async {
    setState(() {
      isWakeLock = on!;
      userPrefsBox.put('isWakeLock', on);
      WakelockPlus.toggle(enable: on);
    });
  }

  @override
  void initState() {
    if (mounted) {
      setState(() {
        isDarkMode = userPrefsBox.get('isDarkMode', defaultValue: false);
        isWakeLock = userPrefsBox.get('isWakeLock', defaultValue: false);

        sessionDuration = userPrefsBox.get('sessionDuration', defaultValue: 25);
        breakDuration = userPrefsBox.get('breakDuration', defaultValue: 5);
      });
      WakelockPlus.toggle(enable: isWakeLock);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: [
              SettingGroup(groupName: "General", settingItems: [
                ExpansionTile(
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  leading: const Icon(Icons.timer_rounded),
                  title: const Text("Duration settings"),
                  shape: shapeBorder,
                  collapsedShape: shapeBorder,
                  childrenPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  children: [
                    const Text(
                      "Session duration",
                      style: TextStyle(fontSize: 12.0),
                    ),
                    Slider(
                      label: sessionDuration.round().toString(),
                      min: 15,
                      max: 60,
                      divisions: 9,
                      value: sessionDuration.roundToDouble(),
                      onChanged: (double val) {
                        setState(() {
                          sessionDuration = val.round();
                        });
                      },
                      onChangeEnd: (double val) async {
                        await userPrefsBox.put('sessionDuration', val.round());
                      },
                    ),
                    const Text(
                      "Break duration",
                      style: TextStyle(fontSize: 12.0),
                    ),
                    Slider(
                      label: breakDuration.round().toString(),
                      min: 5,
                      max: 15,
                      divisions: 2,
                      value: breakDuration.roundToDouble(),
                      onChanged: (double val) {
                        setState(() {
                          breakDuration = val.round();
                        });
                      },
                      onChangeEnd: (double val) async {
                        await userPrefsBox.put('breakDuration', val.round());
                      },
                    ),
                  ],
                ),
                CheckboxListTile(
                    secondary: const Icon(Icons.brightness_high_rounded),
                    value: isWakeLock,
                    shape: shapeBorder,
                    title: const Text("Keep screen on"),
                    onChanged: onWakeLock),
                // Darkmode switch
                SwitchListTile(
                    value: isDarkMode,
                    shape: shapeBorder,
                    title: const Text("Dark mode"),
                    secondary: const Icon(Icons.dark_mode_rounded),
                    onChanged: onDarkMode)
              ]),
              const SettingGroup(groupName: "General", settingItems: [])
            ],
          ),
        ),
      ),
    );
  }
}

class SettingGroup extends StatelessWidget {
  const SettingGroup(
      {super.key, required this.groupName, required this.settingItems});
  final String groupName;
  final List<Widget> settingItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(groupName),
          const SizedBox(
            height: 10.0,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).splashColor,
            ),
            child: Column(
              children: settingItems,
            ),
          )
        ],
      ),
    );
  }
}
