import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:genai/core/hive/local_data.dart';
import 'package:genai/core/hive/open_box.dart';
import 'package:genai/core/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'app_route.dart';
import 'firebase_options.dart';

Position? userLocation;
Box? box;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  userLocation = await UserLocation.getUserPosition();
  box = await openBox('safeLife');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('*********************User is currently signed out!');
      } else {
        print('*********************User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Equipment Management',
      // initialRoute: AppRoutes.ownerPage,
      initialRoute: switch (LocalData.getUserData()?.role) {
        'owner' => AppRoutes.ownerPage,
        'user' => AppRoutes.userPage,
        'admin' => AppRoutes.adminPage,
        _ => AppRoutes.login,
      },
      getPages: AppRoutes.routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
