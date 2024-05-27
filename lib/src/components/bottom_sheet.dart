import 'package:flutter/material.dart';
import 'package:shuchu/src/pages/about_page.dart';

class MenuBottomSheet extends StatelessWidget {
  const MenuBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Wrap(
        children: [
          ClickableListItem(
            icon: Icon(Icons.label_rounded),
            label: "Labels",
            page: Placeholder(),
          ),
          ClickableListItem(
            icon: Icon(Icons.analytics_rounded),
            label: "Statistics",
            page: Placeholder(),
          ),
          ClickableListItem(
            icon: Icon(Icons.sync_rounded),
            label: "Sync",
            page: Placeholder(),
          ),
          ClickableListItem(
            icon: Icon(Icons.settings_rounded),
            label: "Settings",
            page: Placeholder(),
          ),
          ClickableListItem(
            icon: Icon(Icons.info_rounded),
            label: "About",
            page: AboutPage(),
          ),
        ],
      ),
    );
  }
}

class ClickableListItem extends StatelessWidget {
  const ClickableListItem(
      {super.key, required this.icon, required this.label, required this.page});

  final Icon icon;
  final String label;

  final Widget page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        },
        borderRadius: BorderRadius.circular(10.0),
        child: ListTile(
          leading: icon,
          title: Text(label),
        ),
      ),
    );
  }
}
