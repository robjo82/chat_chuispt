import '../../main.dart';
import '../../constants.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyTextField extends StatefulWidget {
  const MyTextField({Key? key}) : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  final _textController = TextEditingController();
  String userPost = '';

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      style: normalText,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'Posez votre question ici...',
          labelStyle: normalText,
          suffixIcon: IconButton(
              color: themeApp.colorScheme.onPrimary,
              onPressed: () {
                setState(() {
                  userPost = _textController.text;
                  context.read<MainAppState>().addQuestion(userPost);
                  _textController.clear();
                });
              },
              icon: const Icon(Icons.send))),
    );
  }
}
