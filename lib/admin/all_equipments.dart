import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genai/app_route.dart';
import 'package:genai/user/bloc/user_data_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class AllEquipments extends StatelessWidget {
  const AllEquipments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Equipments'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Equipment',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) => context
                  .read<UserDataBloc>()
                  .add(SearchDataEvent(text: value, fromfilter: false)),
            ),
          ),
          Expanded(
            child: BlocBuilder<UserDataBloc, UserDataState>(
              builder: (context, state) {
                if ((state is UserDataLoaded && state.equipments.isEmpty) ||
                    state is UserDataError) {
                  return const Center(
                    child: Text(
                      'No equipment found',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                if (state is UserDataLoaded) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: state.equipments.length,
                    itemBuilder: (context, index) {
                      final equipment = state.equipments[index];
                      return Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                            onTap: () => Get.toNamed(AppRoutes.userDetails,
                                arguments: equipment),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            title: Text(
                              equipment.nom,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              equipment.salle ?? '',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            trailing:
                                const Icon(Icons.arrow_forward_ios_outlined)),
                      );
                    },
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
