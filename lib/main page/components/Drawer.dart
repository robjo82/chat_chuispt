import 'package:flutter/material.dart';

import '../../main.dart';
import '../../constants.dart';

class MyDrawer extends StatelessWidget {
  void _showContributionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Contribution'),
          content: Text('Merci pour votre contribution!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: themeApp.colorScheme.background),
            child: Text('Menu', style: titleText),
          ),
          ListTile(
            title: Row(
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Ferme le drawer
                      _showContributionDialog(context);
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.add_circle_outline),
                        const SizedBox(width: 25),
                        Text("Contribuer",
                            style: titleText2.copyWith(color: Colors.black)),
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
