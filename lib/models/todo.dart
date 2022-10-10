import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String title, content, id;

  Todo({
    required this.title,
    required this.content,
    required this.id,
  });

  factory Todo.fromDoc(DocumentSnapshot doc) {
    final map = doc.data() as Map;
    return Todo(
      title: map['title'],
      content: map['content'],
      id: doc.id,
    );
  }

  @override
  int get hashCode => id.hashCode;

  @override
  operator ==(Object e) => (e as Todo).id == id;
}
