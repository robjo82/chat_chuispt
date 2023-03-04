import 'dart:math';
import 'package:flutter/material.dart';

import 'textstyle.dart';
import 'main.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var selectedIndex = 0;

  // store the user's question
  final _textController = TextEditingController();
  String userPost = '';

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 100),
      Text('Chat ChuisPT', style: titleText),
      const SizedBox(height: 50),
      Text('Exemples de questions...', style: titleText2),
      const SizedBox(height: 100),
      const Flexible(child: QuestionGrid()),
      Center(
          child: Padding(
        padding: const EdgeInsets.only(bottom: 75, right: 75),
        child: TextField(
          controller: _textController,
          style: const TextStyle(color: Colors.black, fontSize: 30),
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Posez votre question ici...',
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      userPost = _textController.text;
                      _textController.clear();
                    });
                  },
                  icon: const Icon(Icons.send))),
        ),
      )),
      Text(userPost, style: titleText2),
    ]);
  }
}

class QuestionGrid extends StatelessWidget {
  const QuestionGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> questions = [];
    for (int i = 1; i <= 9; i++) {
      questions.add(
        Container(
          color: Colors.grey[300],
          child: TextButton(
            onPressed: onPressed,
            child: Text('$i', style: titleText2),
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: IconButton(
                onPressed: onPressed,
                icon: const Icon(Icons.favorite),
              ),
            ),
            Center(
              child: IconButton(
                onPressed: onPressed,
                icon: const Icon(Icons.home),
              ),
            ),
            Center(
              child: IconButton(
                onPressed: onPressed,
                icon: const Icon(Icons.work),
              ),
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 150, right: 150),
            child: GridView.count(
              primary: false,
              crossAxisSpacing: 75,
              mainAxisSpacing: 30,
              crossAxisCount: 3,
              children: questions,
            ),
          ),
        ),
      ],
    );
  }

  void onPressed() {}
}
