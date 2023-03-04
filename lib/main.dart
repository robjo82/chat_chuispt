import 'package:flutter/material.dart';

import 'main_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //debug banner desactivation
      title: 'Chat ChuisPt',
      theme:
          ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey)),
      home: const MyHomePage(),
    );
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
        page = const Text('Page 2');
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
        Expanded(child: page),
      ]));
    });
  }
}
