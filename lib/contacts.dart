import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import 'myuser.dart';

StreamSubscription<User?>? authListener;
late User firebaseUser;
String otp = '', verificationId = '';
late MyUser currentUser;
