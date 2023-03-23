import 'dart:async';

import 'package:chat_chuispt/question.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class DataSnapshotMock extends Mock implements DataSnapshot {
  DataSnapshotMock(this.value);

  @override
  final dynamic value;
}

class MockFirebaseDatabase extends Mock implements FirebaseDatabase {}

void main() {
  LocalQuestion localQuestionTest = LocalQuestion(
    id: 1,
    text: 'test',
    blueThumb: 1,
    redThumb: 1,
  );

  test('localQuestion Constructor', () {
    expect(localQuestionTest.id, 1);
    expect(localQuestionTest.text, 'test');
    expect(localQuestionTest.blueThumb, 1);
    expect(localQuestionTest.redThumb, 1);
  });
}
