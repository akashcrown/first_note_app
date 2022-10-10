import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:note_app/addnote.dart';
import 'package:note_app/editnote.dart';
import 'package:note_app/helpers.dart';
import 'package:note_app/with_model.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final ref = FirebaseFirestore.instance.collection('notes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crown Note App'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => AddNote()));
        },
      ),
      body: StreamBuilder(
          stream: ref.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: snapshot.hasData ? snapshot.data!.docs.length : 0,
              itemBuilder: (_, index) {
                String title =
                    (snapshot.data!.docs[index].data() as Map)["title"];
                String content =
                    (snapshot.data!.docs[index].data() as Map)["content"];
                return GestureDetector(
                  onTap: () {
                    to(context,
                        EditNote(docToEdit: snapshot.data!.docs[index]));
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    height: 150,
                    color: Color.fromARGB(255, 214, 207, 207),
                    child: Column(
                      children: [
                        Text(title),
                        Text(content),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
