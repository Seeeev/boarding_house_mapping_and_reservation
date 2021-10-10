import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddBldg {
  static void add({required Map<String, dynamic> data}) {
    FirebaseFirestore.instance.collection('boarding_houses').add(data);
  }
}
