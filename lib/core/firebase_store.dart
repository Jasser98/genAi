import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:genai/core/hive/local_data.dart';
import 'package:genai/model/equipment.dart';

class FirebaseStore {
  static final firebaseFirestore = FirebaseFirestore.instance;

  static Future<void> addUserDataToFireStore({
    required String email,
    required String username,
    required String role,
    required String userId,

    String? phone,
  }) async {
   
    CollectionReference ref = firebaseFirestore.collection('users');
    ref.doc(userId).set({
      'id': userId,
      'email': email,
      'role': role,
      'userName': username,
      'equipments': [],
      if (phone != null) 'phone': phone,
    });
  }

  static Future<void> addEquipmenToUser(Equipment equipment) async {
    await firebaseFirestore
        .collection('users')
        .doc(LocalData.getUserData()!.id)
        .update({
      "equipments": FieldValue.arrayUnion([equipment.toJson()])
    });
  }
}
