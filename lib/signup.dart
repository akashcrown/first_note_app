import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/contacts.dart';
import 'package:note_app/home_page.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String name = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup Screen'),
      ),
      body: Container(
          child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              label: Text('Enter your name'),
            ),
            onChanged: (v) {
              name = v;
            },
          ),
          ElevatedButton(
            onPressed: () async {
              if (name.isEmpty) {
                return;
              }
              await FirebaseFirestore.instance.collection('users').add({
                'phone': firebaseUser.phoneNumber,
                'name': name,
              });
              Get.offAll(() => Homepage());
            },
            child: Text('Signup'),
          ),
        ],
      )),
    );
  }
}
