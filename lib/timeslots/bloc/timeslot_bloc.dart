import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:frontend/app/model/timeslot.dart';
import 'package:frontend/timeslots/repositories/timeslot_repository.dart';
import 'package:meta/meta.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

part 'timeslot_event.dart';
part 'timeslot_state.dart';

class TimeslotBloc extends Bloc<TimeslotEvent, TimeslotState> {
  TimeslotBloc({required this.timeslotRepository}) : super(TimeslotInitial()) {
    on<GetTimeslots>(
      (event, emit) => loadTimeslots(emit, event),
    );
    on<LoadCalendarTapDetails>(
          (event, emit) => loadCalendarTapDetails(emit, event),
    );
  }

  final TimeslotRepository timeslotRepository;

  Future<void> loadTimeslots(
      Emitter<TimeslotState> emit, GetTimeslots event,) async {

    return emit(
      TimeslotsLoaded(
        workspaceId: event.workspaceId,
        timeSlots: await timeslotRepository.getTimeslots(
          variables: <String, dynamic>{'workspaceId': event.workspaceId},
        ),
      ),
    );
  }

  Future<void> loadCalendarTapDetails(
      Emitter<TimeslotState> emit, LoadCalendarTapDetails event,) async {
    return emit(CalendarTapDetailsLoaded(event.calendarTapDetails));
  }
}
