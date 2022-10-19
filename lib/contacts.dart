import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

StreamSubscription<User?>? authListener;
late User firebaseUser;
