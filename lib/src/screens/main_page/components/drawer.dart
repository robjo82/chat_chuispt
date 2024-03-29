import 'package:chat_chuispt/src/repositories/authentication/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_chuispt/assets/constants/constants.dart';
import 'package:chat_chuispt/src/repositories/database/database_repository.dart';
import 'package:chat_chuispt/main.dart';

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
    final DatabaseService databaseService = DatabaseService();
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Contribution'),
          content: TextField(
            controller: controller,
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
                databaseService.addResponse(controller.text, 0, 0);
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
    UserRepository userRepository = UserRepository();

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
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.restore,
                            color: themeApp.colorScheme.onPrimaryContainer),
                        const SizedBox(width: 25),
                        Text("Réinitialisation", style: titleText2),
                      ],
                    )),
                // si l'utilisateur est connecté, affiche le bouton de déconnexion, sinon affiche le bouton de connexion
                userRepository.getCurrentUser() == null
                    ? // * "Google Sign In" button * //
                    TextButton(
                        onPressed: () => {
                              userRepository.signInWithGoogle(),
                              appState.clearQuestionList(),
                              Navigator.pop(context)
                            },
                        child: Row(
                          children: [
                            Icon(Icons.login,
                                color: themeApp.colorScheme.onPrimaryContainer),
                            const SizedBox(width: 25),
                            Text("Se connecter", style: titleText2),
                          ],
                        ))
                    : // * "Google Sign Out" button * //
                    TextButton(
                        onPressed: () => {
                              userRepository.signOut(),
                              appState.clearQuestionList(),
                              Navigator.pop(context)
                            },
                        child: Row(
                          children: [
                            Icon(Icons.logout,
                                color: themeApp.colorScheme.onPrimaryContainer),
                            const SizedBox(width: 25),
                            Text("Se déconnecter", style: titleText2),
                          ],
                        )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
