part of 'user_data_bloc.dart';

sealed class UserDataEvent {}

class GetDataFiltredEvent extends UserDataEvent {}

class GetAllDataEvent extends UserDataEvent {}

class SearchDataEvent extends UserDataEvent {
  final String text;
  final bool fromfilter;

  SearchDataEvent({
    required this.text,
    this.fromfilter = true,
  });
}
