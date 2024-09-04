part of 'user_data_bloc.dart';

sealed class UserDataState {}

final class UserDataLoading extends UserDataState {}

final class UserDataLoaded extends UserDataState {
  final List<Equipment> equipments;

  UserDataLoaded({required this.equipments});
}

final class UserDataError extends UserDataState {}
