import 'package:chatchuispt/main.dart';
import 'package:chatchuispt/assets/constants/constants.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyTextField extends StatefulWidget {
  const MyTextField({Key? key}) : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    String message = _controller.text.trim();
    if (message.isNotEmpty) {
      if (kDebugMode) {
        print('Message envoyé: $message');
      }
      var appState = context.read<MainAppState>();
      appState.addQuestion(message);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: themeApp.colorScheme.secondary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(
                0, 3), // position de l'ombre par rapport au conteneur
          ),
        ],
      ),
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
