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
                ListTile(
                  leading: const Icon(Icons.timer_rounded),
                  title: const Text("Duration settings"),
                  onTap: () {},
                  shape: shapeBorder,
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
