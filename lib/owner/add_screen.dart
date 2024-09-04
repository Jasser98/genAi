import 'package:flutter/material.dart';
import 'package:genai/main.dart';
import 'package:get/get.dart';

import '../equipment_controller.dart';
import '../model/equipment.dart';

class AddEquipmentScreen extends StatelessWidget {
  final EquipmentController controller = Get.find();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController salleController = TextEditingController();
  final TextEditingController emplacementController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final RxBool disponibility = false.obs;

  AddEquipmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Equipment'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(nomController, 'Nom', Icons.build),
              _buildTextField(salleController, 'Salle', Icons.meeting_room),
              _buildTextField(
                  emplacementController, 'Emplacement', Icons.place),
              _buildTextField(
                  descriptionController, 'Description', Icons.description),
              // _buildTextField(latitudeController, 'Latitude', Icons.map),
              // _buildTextField(
              //     longitudeController, 'Longitude', Icons.map_outlined),
              Obx(() => CheckboxListTile(
                    title: const Text('Disponibility'),
                    value: disponibility.value,
                    onChanged: (value) {
                      disponibility.value = value!;
                    },
                    activeColor: Theme.of(context).primaryColor,
                    controlAffinity: ListTileControlAffinity.leading,
                  )),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () async {
                    final equipment = Equipment(
                      nom: nomController.text,
                      salle: salleController.text,
                      emplacement: emplacementController.text,
                      description: descriptionController.text,
                      disponibility: disponibility.value,
                      latitude: userLocation?.latitude,
                      longitude: userLocation?.longitude,
                    );

                    await controller.addEquipment(equipment);
                    Get.back();
                  },
                  child: const Text('Add Equipment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
