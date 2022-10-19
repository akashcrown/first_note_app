import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/contacts.dart';
import 'package:note_app/signup.dart';

import 'home_page.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({Key? key}) : super(key: key);

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  String phone = '', otp = '', verificationId = '';

  @override
  void initState() {
    super.initState();
    if (authListener == null) {
      authListener = FirebaseAuth.instance.authStateChanges().listen(
        (user) async {
          if (user == null) {
            // user is logout
            Get.offAll(() => PhoneLoginScreen());
          } else {
            // user is just login
            firebaseUser = user;

            // checking if this phone number data is available in my firestore database (users)
            var query = await FirebaseFirestore.instance
                .collection('users')
                .where('phone', isEqualTo: firebaseUser.phoneNumber)
                .get();
            if (query.docs.isEmpty) {
              // its a new user
              Get.off(() => SignupScreen());
            } else {
              Get.offAll(() => Homepage());
            }
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Login'),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => phone = value,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'phone',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                onChanged: (value) => otp = value,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'OTP',
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(20),
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: '+91' + phone,
                    verificationCompleted: (credential) {
                      FirebaseAuth.instance.signInWithCredential(credential);
                    },
                    verificationFailed: (e) {
                      print(e.message);
                    },
                    codeSent: (vid, token) {
                      verificationId = vid;
                    },
                    codeAutoRetrievalTimeout: (vid) {
                      verificationId = vid;
                    },
                    // timeout: Duration(minutes: 1),
                  );
                },
                child: Text(
                  'Send OTP',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(20),
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signInWithCredential(
                    PhoneAuthProvider.credential(
                      verificationId: verificationId,
                      smsCode: otp,
                    ),
                  );
                },
                child: Text(
                  'Verify OTP',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
