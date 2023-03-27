import 'package:chat_chuispt/constants.dart';
import 'package:chat_chuispt/main.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyTextField extends StatefulWidget {
  const MyTextField({Key? key}) : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    String message = _controller.text.trim();
    if (message.isNotEmpty) {
      print('Message envoyé: $message');
      var appState = context.read<MainAppState>();
      appState.addQuestion(message);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: themeApp.colorScheme.primaryContainer,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.text,
              style: normalText,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: 'Écrivez votre message ici...',
                hintStyle: normalText,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (value) {
                _sendMessage();
              },
            ),
          ),
          IconButton(
            onPressed: _sendMessage,
            icon: Icon(Icons.send,
                color: themeApp.colorScheme.onPrimaryContainer),
          ),
        ],
      ),
    );
  }
}
