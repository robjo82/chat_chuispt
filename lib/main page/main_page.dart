import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../main.dart';

import 'components/History.dart';
import 'components/QuestionsGrid.dart';
import 'components/TextField.dart';
import 'components/Drawer.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // store the user's question
  String userPost = '';

  @override
  Widget build(BuildContext context) {
    // * Variables :
    var appState = context.watch<MainAppState>(); // état de l'application
    MyTextField textField = const MyTextField(); // le champ de texte
    MyDrawer myDrawer = MyDrawer(); // le drawer

    return Consumer<MainAppState>(builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(
            title: Text('Chat ChuisPT', style: titleText),
            backgroundColor: themeApp.colorScheme.primaryContainer,
            elevation: 5,
            leading: Builder(builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () =>
                    Scaffold.of(context).openDrawer(), // open the drawer),
              );
            })),
        drawer: myDrawer,
        body: appState.questionsList.isEmpty
            ? Container(
                // ! si la liste de questions est vide
                color: themeApp.colorScheme.background,
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    Text('Exemples de questions...', style: titleText2),
                    const SizedBox(height: 5),
                    const Expanded(child: QuestionGrid()),
                    Padding(
                        padding: const EdgeInsets.only(
                            bottom: 25, top: 25, right: 15, left: 15),
                        child: textField),
                  ],
                ),
              )
            : Container(
                // ! si la liste de questions n'est pas vide
                color: themeApp.colorScheme.background,
                child: Column(children: [
                  const Flexible(child: History()),
                  Padding(padding: const EdgeInsets.all(20), child: textField),
                ]),
              ),
      );
    });
  }
}
