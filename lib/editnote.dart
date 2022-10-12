import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class EditNote extends StatefulWidget {
  DocumentSnapshot docToEdit;
  EditNote({required this.docToEdit});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  @override
  void initState() {
    title =
        TextEditingController(text: (widget.docToEdit.data() as Map)['title']);
    content = TextEditingController(
        text: (widget.docToEdit.data() as Map)['content']);
    super.initState();
  }

  // final style = TextStyle(fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        actions: [
          IconButton(
            onPressed: () {
              widget.docToEdit.reference.update({
                'title': title.text,
                'content': content.text,
              }).whenComplete(
                () => Navigator.pop(context),
              );
            },
            icon: Icon(Icons.save),
          ),
          IconButton(
              onPressed: () {
                widget.docToEdit.reference.delete().whenComplete(
                      () => Navigator.pop(context),
                    );
              },
              icon: Icon(Icons.delete_forever)),
        ],
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
              ),
              child: TextField(
                style: GoogleFonts.secularOne(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                controller: title,
                decoration: InputDecoration(labelText: 'Title'),
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
                  decoration: InputDecoration(labelText: 'content'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
