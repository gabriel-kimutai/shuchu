import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("About"),
      ),
      body: const Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.abc,
                size: 100.0,
              ),
              Text("Name")
            ],
          )
        ],
      ),
    );
  }
}
