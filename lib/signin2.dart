import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'myuser.dart';
import 'otp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/contacts.dart';
import 'package:note_app/signup.dart';

import 'home_page.dart';

class Phonelogin2 extends StatefulWidget {
  const Phonelogin2({Key? key}) : super(key: key);

  @override
  State<Phonelogin2> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<Phonelogin2> {
  TextEditingController countryController = TextEditingController();
  String phone = '';

  @override
  void initState() {
    // countryController.text = "+91";
    super.initState();
    if (authListener == null) {
      authListener = FirebaseAuth.instance.authStateChanges().listen(
        (user) async {
          if (user == null) {
            // user is logout
            Get.offAll(() => Phonelogin2());
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
              currentUser = MyUser.fromDoc(query.docs.first);
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
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/noteapp.jpg',
                width: 150,
                height: 150,
              ),
              //  Image.network(
              //   'https://play-lh.googleusercontent.com/GysplKrYyh0HC3FNg4lKXNdAwZYWPj1EovbEGrCkNedFlWz28qJWKVEfTME5vNyeQtc=w240-h480-rw',
              //   width: 150,
              //   height: 150,
              // ),
              SizedBox(
                height: 25,
              ),
              Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "We need to register your phone without getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    // SizedBox(
                    //   width: 40,
                    //   child: TextField(
                    //     controller: countryController,
                    //     keyboardType: TextInputType.number,
                    //     decoration: InputDecoration(
                    //       border: InputBorder.none,
                    //     ),
                    //   ),
                    // ),
                    // Text(
                    //   "|",
                    //   style: TextStyle(fontSize: 33, color: Colors.grey),
                    // ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextField(
                      // keyboardType: TextInputType.phone,
                      onChanged: (value) => phone = value,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "Phone",
                      ),
                    ))
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      Get.to(MyVerify());
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: '+91' + phone,
                        verificationCompleted: (credential) {
                          FirebaseAuth.instance
                              .signInWithCredential(credential);
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

                      Get.snackbar(
                        "NOTE APP",
                        "OTP SENT",
                        icon: Icon(Icons.person, color: Colors.white),
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                      );
                    },
                    child: Text("Send the code")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
