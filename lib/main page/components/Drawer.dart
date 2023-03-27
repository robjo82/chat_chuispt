import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../database_service.dart';
import '../../main.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  //! dialog window of remerciement
  void _showThankYouDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('Merci pour votre contribution !'),
          icon: const Icon(Icons.check_circle_outline_outlined),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fermer', style: normalText),
            ),
          ],
        );
      },
    );
  }

  //! dialog window of contribution
  void _showContributionDialog(BuildContext context) {
    final DatabaseService _databaseService = DatabaseService();
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
                // Ajoute la nouvelle réponse à la base de données
                _databaseService.addResponse(_controller.text, 0, 0);
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
