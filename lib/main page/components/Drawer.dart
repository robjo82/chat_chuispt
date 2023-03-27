import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
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
              child: Text('Annuler', style: normalText),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Ferme la boîte de dialogue de contribution
                _showThankYouDialog(
                    context); // Affiche le message de remerciement
              },
              child: Text('Envoyer', style: normalText),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MainAppState>(); // état de l'application

    return Drawer(
      backgroundColor: themeApp.colorScheme.primaryContainer.withOpacity(1),
      child: ListView(
        children: [
          ListTile(
            title: Column(
              children: [
                const SizedBox(height: 35),

                // * "Contribuer" button * //
                TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Ferme le drawer
                      _showContributionDialog(context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.add_circle_outline,
                            color: themeApp.colorScheme.onPrimaryContainer),
                        const SizedBox(width: 25),
                        Text("Contribuer", style: titleText2),
                      ],
                    )),
                const SizedBox(height: 15),

                // * "Reinitialisation" button * //
                TextButton(
                    onPressed: () {
                      appState.clearQuestionList();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.restore,
                            color: themeApp.colorScheme.onPrimaryContainer),
                        const SizedBox(width: 25),
                        Text("Réinitialisation", style: titleText2),
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
