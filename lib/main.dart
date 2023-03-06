import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false, //debug banner desactivation
        title: 'Chat ChuisPt',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.black)),
        home: const MyHomePage(),
      ),
    );
  }
}

class MainAppState extends ChangeNotifier {
  List<String> questionsList = [];
  List<String> responsesList = [];
  var historyKey = GlobalKey();

  void addQuestion(String question) {
    if (question != '') {
      questionsList.insert(0, question);
      notifyListeners();
      var animatedList = historyKey.currentState as AnimatedListState?;
      animatedList?.insertItem(0);
    }
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = MainPage();
        break;
      case 1:
        page = const Text('Page2');
        break;
      case 2:
        page = const Text('Page 3');
        break;

      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
          body: Row(children: [
        SafeArea(
            child: NavigationRail(
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.home),
              label: Text('Main'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.favorite_border),
              label: Text('Favorites'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.bookmark_border),
              label: Text('Bookmarks'),
            ),
          ],

          // Destination selected
          selectedIndex: selectedIndex,
          onDestinationSelected: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
        )),
        Expanded(child: Container(child: page)),
      ]));
    });
  }
}
