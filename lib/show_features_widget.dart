import 'package:flutter/material.dart';
import 'package:chat_chuispt/database_service.dart';

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

class DataListWidget extends StatelessWidget {
  final Stream<List<Map<String, dynamic>>> stream;

  const DataListWidget({Key? key, required this.stream}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final question = data[index];
              final id = question['id'] as String;
              final text = question['text'] as String;
              final blueThumb = question['blue_thumb'] as int;
              final redThumb = question['red_thumb'] as int;

              return ListTile(
                title: Text(text),
                subtitle: Text('$blueThumb - $redThumb'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.thumb_up),
                      onPressed: () {
                        DatabaseService().updateBlueThumb(id, blueThumb + 1);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.thumb_down),
                      onPressed: () {
                        DatabaseService().updateRedThumb(id, redThumb + 1);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        DatabaseService().deleteQuestion(id);
                      },
                    ),
                  ],
                ),
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

// The goal of this widget is to allow the user to add a new question to the database
// The user can add a question by typing it in the text field and clicking on the button
// The question is added to the database with the id, text, blue thumb and red thumb
class AddQuestionWidget extends StatefulWidget {
  const AddQuestionWidget({Key? key}) : super(key: key);

  @override
  _AddQuestionWidgetState createState() => _AddQuestionWidgetState();
}

class _AddQuestionWidgetState extends State<AddQuestionWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
        ),
        ElevatedButton(
          onPressed: () {
            DatabaseService().addResponse(
              _controller.text,
              0,
              0,
            );
          },
          child: const Text('Add question'),
        ),
      ],
    );
  }
}
