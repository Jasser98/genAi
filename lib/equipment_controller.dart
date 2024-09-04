import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:genai/core/firebase_store.dart';
import 'package:genai/core/hive/local_data.dart';
import 'package:get/get.dart';

import 'model/equipment.dart';

class EquipmentController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final equipments = <Equipment>[].obs;
  var filteredEquipments = <Equipment>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEquipments();
    filteredEquipments.value = equipments;
  }

  Future<void> fetchEquipments() async {
    try {
      // Start loading
      isLoading(true);

      // Fetch data from Firestore
      final querySnapshot = await _firestore
          .collection('users')
          .doc(LocalData.getUserData()!.id)
          .get();
      List<Equipment> listEquipments = [];

      // Map the fetched documents to your Equipment model
      for (var e in (querySnapshot.data()!['equipments'])) {
        listEquipments.add(Equipment.fromJson(e));
      }

      equipments.value = listEquipments;
    } catch (e) {
      // print(e);
      Get.snackbar('Error', 'Failed to load equipments');
    } finally {
      // Stop loading
      isLoading(false);
    }
  }

  Future<void> addEquipment(Equipment equipment) async {
    try {
      // Generate a unique document ID
      String docId = _firestore.collection('equipments').doc().id;
      // Optionally, save the docId in the Equipment object if you plan to update later
      equipment.id = docId;
      // Add equipment to Firestore with the generated ID
      await _firestore
          .collection('equipments')
          .doc(docId)
          .set(equipment.toJson());
      await FirebaseStore.addEquipmenToUser(equipment);
      print(docId);

      // Refresh the list after adding
      fetchEquipments();
    } catch (e) {
      Get.snackbar('Error', 'Failed to add equipment');
    }
  }

  // Update existing equipment in Firestore
  Future<void> updateEquipment(
      String documentId, Equipment equipment, int index) async {
    try {
      await _firestore
          .collection('equipments')
          .doc(documentId)
          .update(equipment.toJson());

      equipments[index] = equipment;
      await _firestore
          .collection('users')
          .doc(LocalData.getUserData()!.id)
          .update({
        'equipments': equipments.map((element) => element.toJson()).toList()
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to update equipment');
    }
  }

  // Delete equipment from Firestore
  Future<void> deleteEquipment(String documentId, int index) async {
    try {
      await _firestore.collection('equipments').doc(documentId).delete();
      equipments.removeAt(index);
      await _firestore
          .collection('users')
          .doc(LocalData.getUserData()!.id)
          .update({
        'equipments': equipments.map((element) => element.toJson()).toList()
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete equipment');
    }
  }

  void searchEquipment(String query) {
    if (query.isEmpty) {
      filteredEquipments.value = equipments;
    } else {
      filteredEquipments.value = equipments.where((equipment) {
        return equipment.nom.toLowerCase().contains(query.toLowerCase()) ||
            equipment.salle!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }
}
