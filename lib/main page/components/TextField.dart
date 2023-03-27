import 'package:chat_chuispt/constants.dart';
import 'package:chat_chuispt/main.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyTextField extends StatefulWidget {
  const MyTextField({Key? key}) : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  final _textController = TextEditingController();
  String userQuestion = '';

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: true,
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
                  userQuestion = _textController.text;
                  context.read<MainAppState>().addQuestion(userQuestion);
                  _textController.clear();
                });
              },
              icon: const Icon(Icons.send))),
    );
  }
}
