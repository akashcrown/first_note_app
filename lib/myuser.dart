import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  String id, phone, name;

  MyUser({
    required this.id,
    required this.phone,
    required this.name,
  });

  factory MyUser.fromDoc(DocumentSnapshot doc) {
    Map map = doc.data() as Map;
    return MyUser(
      id: doc.id,
      phone: map['phone'],
      name: map['name'],
    );
  }
}
