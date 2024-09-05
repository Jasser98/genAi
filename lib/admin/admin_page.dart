import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:genai/core/hive/local_data.dart';
import 'package:get/get.dart';

import '../app_route.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              LocalData.removeUserData();
              Get.offAllNamed(AppRoutes.login);
            },
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Logout',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Admin Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('User Management'),
              onTap: () {
                Get.toNamed(AppRoutes.manageOwners);
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & Support'),
              onTap: () {
                // Add navigation to help & support
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Get.offAllNamed(AppRoutes.login);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.allEquipments),
                    child: const Card(
                      elevation: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.medical_services,
                              size: 50, color: Colors.blue),
                          SizedBox(height: 10),
                          Center(
                            child: Text('Equipment Management',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.reportsPage),
                    child: const Card(
                      elevation: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.analytics, size: 50, color: Colors.blue),
                          SizedBox(height: 10),
                          Center(
                            child: Text('Reports',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Add more cards for other admin functionalities
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
