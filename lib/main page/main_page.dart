import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../main.dart';

import 'components/History.dart';
import 'components/QuestionsGrid.dart';
import 'components/TextField.dart';

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
    MyDrawer myDrawer = const MyDrawer(); // le drawer

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
                color: themeApp.colorScheme.background,
                child: Column(children: [
                  const SizedBox(height: 25),
                  const Flexible(child: History()),
                  Padding(padding: const EdgeInsets.all(20), child: textField),
                ]),
              ),
      );
    });
  }
}

class LeftBar extends StatefulWidget {
  const LeftBar({Key? key}) : super(key: key);

  @override
  State<LeftBar> createState() => _LeftBarState();
}

class _LeftBarState extends State<LeftBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: themeApp.colorScheme.surface,
        width: 75,
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 75)),
            IconButton(
                iconSize: 35,
                color: themeApp.colorScheme.onPrimaryContainer,
                onPressed: () {
                  setState(() {
                    context.read<MainAppState>().clearQuestionList();
                  });
                },
                icon: const Icon(Icons.refresh))
          ],
        ));
  }
}

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final List<String> _items = ['Item 1', 'Item 2', 'Item 3'];

  void _addItem() {
    setState(() {
      _items.add('Item ${_items.length + 1}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: _items.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return ListTile(
                title: const Text('Add item'),
                onTap: () {
                  _addItem();
                });
          }
          return ListTile(
            title: Text(_items[index - 1]),
            onTap: () {
              // Do something when the item is tapped
            },
          );
        },
      ),
    );
  }
}
