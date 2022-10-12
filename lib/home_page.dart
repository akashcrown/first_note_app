import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'addnote.dart';
import 'editnote.dart';
import 'helpers.dart';

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
        backgroundColor: Color.fromARGB(255, 100, 105, 231),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.note_add),
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
                    // color: Color.fromARGB(255, 218, 111, 111),
                    color: Colors
                        .primaries[Random().nextInt(Colors.primaries.length)],
                    child: Column(
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.secularOne(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          content,
                          style: GoogleFonts.caveat(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
