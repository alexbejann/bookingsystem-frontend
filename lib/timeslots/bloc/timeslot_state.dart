part of 'timeslot_bloc.dart';

@immutable
abstract class TimeslotState {}

class TimeslotInitial extends TimeslotState {
  TimeslotInitial();
}

class TimeslotLoading extends TimeslotState {
  TimeslotLoading();
}

class TimeslotsLoaded extends TimeslotState {
  TimeslotsLoaded({required this.workspaceId, required this.timeSlots});
  final List<Timeslot> timeSlots;
  final String workspaceId;
}

class CalendarTapDetailsLoaded extends TimeslotState {
  CalendarTapDetailsLoaded(this.calendarTapDetails);
  final CalendarTapDetails calendarTapDetails;
}

class TimeslotError extends TimeslotState {
  TimeslotError(this.error);
  final String error;
}
