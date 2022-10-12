import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class AddNote extends StatelessWidget {
  AddNote({super.key});

  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  CollectionReference ref = FirebaseFirestore.instance.collection('notes');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                ref.add({
                  'title': title.text,
                  'content': content.text,
                }).whenComplete(() => Navigator.pop(context));
              },
              icon: Icon(Icons.save)),
        ],
        backgroundColor: Color.fromARGB(255, 225, 57, 124),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(4.0),
                ),

                // border: Border.all()
              ),
              child: TextField(
                style: GoogleFonts.secularOne(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                controller: title,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(4.0),
                  ),
                ),
                child: TextField(
                  style: GoogleFonts.caveat(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  controller: content,
                  maxLines: null,
                  // expands: true,
                  decoration: InputDecoration(
                    labelText: 'Content',
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
