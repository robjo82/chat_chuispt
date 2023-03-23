import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref('');

  Stream<List<String>> getTexts() {
    return _database.child('questions').onValue.map((event) {
      final texts = <String>[];

      final List<dynamic>? data = event.snapshot.value as List<dynamic>?;
      if (data != null) {
        for (final question in data) {
          final text = question['text'] as String?;
          if (text != null) {
            texts.add(text);
          }
        }
      }

      return texts;
    });
  }
}

class TextListWidget extends StatelessWidget {
  final Stream<List<String>> stream;

  const TextListWidget({Key? key, required this.stream}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final texts = snapshot.data!;
          return ListView.builder(
            itemCount: texts.length,
            itemBuilder: (context, index) {
              final text = texts[index];
              return ListTile(
                title: Text(text),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
