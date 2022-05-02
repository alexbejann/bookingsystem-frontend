part of 'add_timeslot_bloc.dart';

@immutable
abstract class AddTimeslotEvent {
  const AddTimeslotEvent();
}

class SaveTimeslot extends AddTimeslotEvent {
  const SaveTimeslot(
      {required this.title, required this.from, required this.to,});

  final String title;
  final DateTime from;
  final DateTime to;
}
