import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_app/addnote.dart';
import 'package:note_app/helpers.dart';

class WithoutModel extends StatefulWidget {
  const WithoutModel({super.key});

  @override
  State<WithoutModel> createState() => _WithoutModelState();
}

class _WithoutModelState extends State<WithoutModel> {
  List<Map> todoList = [];
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> stream;

  @override
  void initState() {
    super.initState();
    fetchTodos();
    stream = FirebaseFirestore.instance.collection('notes').snapshots().listen(
      (_) {
        fetchTodos();
      },
    );
  }

  @override
  void dispose() {
    stream.cancel();
    super.dispose();
  }

  fetchTodos() async {
    todoList.clear();
    final query = await FirebaseFirestore.instance.collection('notes').get();
    final docs = query.docs;
    for (final doc in docs) {
      final map = doc.data();
      map['id'] = doc.id;
      todoList.add(map);
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: Container(
        child: ListView(children: [
          for (final todo in todoList)
            ListTile(
              title: Text(todo['title']),
              subtitle: Text(todo['content']),
              trailing: IconButton(
                icon: Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('notes')
                      .doc(todo['id'])
                      .delete();
                },
              ),
            ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          to(context, AddNote());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
