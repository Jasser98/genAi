import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genai/core/location.dart';
import 'package:genai/model/equipment.dart';

part 'user_data_event.dart';
part 'user_data_state.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  UserDataBloc() : super(UserDataLoading()) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    List<Equipment> listEquipmentsFiltred = [];
    List<Equipment> allEquipments = [];
    on<UserDataEvent>((event, emit) async {
      if (event is GetDataFiltredEvent) {
        emit(UserDataLoading());
        // Fetch data from Firestore
        final querySnapshot = await firestore.collection('equipments').get();

        // Map the fetched documents to your Equipment model
        for (var e in (querySnapshot.docs)) {
          final equipment = Equipment.fromJson(e.data());
          final lat = equipment.latitude;
          final long = equipment.longitude;
          if (lat != null &&
              long != null &&
              UserLocation.calculateDistance(lat, long) < 5) {
            listEquipmentsFiltred.add(equipment);
          }
        }
        emit(UserDataLoaded(equipments: listEquipmentsFiltred));
      } else if (event is SearchDataEvent) {
        if (event.text.isEmpty) {
          if (event.fromfilter) {
            emit(UserDataLoaded(equipments: listEquipmentsFiltred));
          } else {
            emit(UserDataLoaded(equipments: allEquipments));
          }
        }
        if (event.fromfilter) {
          emit(UserDataLoaded(
              equipments: listEquipmentsFiltred
                  .where((element) => element.nom.contains(event.text))
                  .toList()));
        } else {
          emit(UserDataLoaded(
              equipments: allEquipments
                  .where((element) => element.nom.contains(event.text))
                  .toList()));
        }
      } else if (event is GetAllDataEvent) {
        emit(UserDataLoading());
        // Fetch data from Firestore
        final querySnapshot = await firestore.collection('equipments').get();

        // Map the fetched documents to your Equipment model
        for (var e in (querySnapshot.docs)) {
          final equipment = Equipment.fromJson(e.data());
          allEquipments.add(equipment);
        }
        emit(UserDataLoaded(equipments: allEquipments));
      }
    });
  }
}
