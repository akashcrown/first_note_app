import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String id, title, content, userId;

  Todo({
    required this.id,
    required this.title,
    required this.content,
    required this.userId,
  });

  factory Todo.fromDoc(DocumentSnapshot doc) {
    Map map = doc.data() as Map;
    return Todo(
      id: doc.id,
      title: map['title'],
      content: map['content'],
      userId: map['userId'],
    );
  }

  @override
  bool operator ==(Object o) => o is Todo && o.id == id;
}
