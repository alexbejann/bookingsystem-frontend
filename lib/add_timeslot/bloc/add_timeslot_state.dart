part of 'add_timeslot_bloc.dart';

@immutable
abstract class AddTimeslotState {
  const AddTimeslotState();
}

class AddTimeslotInitial extends AddTimeslotState {

  const AddTimeslotInitial({required this.from, required this.to});
  final DateTime from;
  final DateTime to;
}

class SavedTimeslot extends AddTimeslotState {

  const SavedTimeslot({required this.timeslot});

  final Timeslot timeslot;
}

class SaveTimeslotFailure extends AddTimeslotState {

  const SaveTimeslotFailure(this.error);

  final String error;
}
