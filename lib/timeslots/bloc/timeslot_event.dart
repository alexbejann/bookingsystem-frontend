part of 'timeslot_bloc.dart';

@immutable
abstract class TimeslotEvent {
  const TimeslotEvent();
}

class GetTimeslots extends TimeslotEvent {
  const GetTimeslots(this.workspaceId);

  final String workspaceId;
}

class DeleteTimeslot extends TimeslotEvent {
  const DeleteTimeslot(this.timeslotId);

  final String timeslotId;
}

class LoadCalendarTapDetails extends TimeslotEvent {
  const LoadCalendarTapDetails(this.calendarTapDetails);

  final CalendarTapDetails calendarTapDetails;
}

class AddTimeslot extends TimeslotEvent {
  const AddTimeslot(
      {required this.title, required this.from, required this.to});

  final String title;
  final DateTime from;
  final DateTime to;
}
