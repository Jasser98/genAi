import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genai/admin/admin_page.dart';
import 'package:genai/admin/all_equipments.dart';
import 'package:genai/auth/login.dart';
import 'package:genai/auth/signup.dart';
import 'package:genai/model/equipment.dart';
import 'package:genai/owner/add_screen.dart';
import 'package:genai/owner/owner_page.dart';
import 'package:genai/owner/update_screen.dart';
import 'package:genai/user/bloc/user_data_bloc.dart';
import 'package:genai/user/equipments_details.dart';
import 'package:genai/user/user_page.dart';
import 'package:get/get.dart';
import 'package:genai/admin/user_management.dart';


class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String addEquipment = '/add';
  static const String updateEquipment = '/update';
  static const String ownerPage = '/owner';
  static const String userPage = '/user_page';
  static const String adminPage = '/admin_page';
  static const String userDetails = '/user_details';
  static const String allEquipments = '/all_equipments';
  static const String manageOwners = '/manage_owners';


  static List<GetPage> routes = [
    GetPage(
      name: login,
      page: () => const Login(),
    ),
    GetPage(
      name: register,
      page: () => const SignUp(),
    ),
    GetPage(
      name: addEquipment,
      page: () => AddEquipmentScreen(),
    ),
    GetPage(
      name: updateEquipment,
      page: () {
        List data = Get.arguments;
        return UpdateEquipmentScreen(equipment: data.first, index: data.last);
      },
    ),
    GetPage(
      name: ownerPage,
      page: () => OwnerScreen(),
    ),
    GetPage(
      name: userPage,
      page: () => BlocProvider(
        create: (context) => UserDataBloc()..add(GetDataFiltredEvent()),
        child: const UserPage(),
      ),
    ),
    GetPage(
      name: adminPage,
      page: () => const AdminScreen(),
    ),
    GetPage(
      name: manageOwners,
      page: () => ManageOwnersPage(),
    ),
    GetPage(
      name: userDetails,
      page: () {
        Equipment equipment = Get.arguments;
        return LocationDetailsScreen(
          locationData: equipment,
        );
      },
    ),
    GetPage(
      name: allEquipments,
      page: () {
        return BlocProvider(
          create: (context) => UserDataBloc()..add(GetAllDataEvent()),
          child: const AllEquipments(),
        );
      },
    ),
  ];
}
