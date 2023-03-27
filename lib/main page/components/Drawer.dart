import 'package:flutter/material.dart';

import '../../constants.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  //! dialog window of remerciement
  void _showThankYouDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Merci !'),
          content: const Text('Merci pour votre contribution!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  //! dialog window of contribution
  void _showContributionDialog(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Contribution'),
          content: TextField(
            controller: _controller,
            decoration:
                const InputDecoration(hintText: 'Entrez votre texte ici'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Ferme la boîte de dialogue de contribution
                _showThankYouDialog(
                    context); // Affiche le message de remerciement
              },
              child: const Text('Envoyer'),
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
        children: [
          DrawerHeader(
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.background),
            child: Text('Menu', style: titleText, textAlign: TextAlign.center),
          ),
          ListTile(
            title: Row(
              children: [
                // * "Contribuer" * //
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
                            style: titleText2.copyWith(color: Colors.black))
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
