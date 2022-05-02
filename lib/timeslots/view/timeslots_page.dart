import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/app/model/timeslot.dart';
import 'package:frontend/timeslots/repositories/timeslot_repository.dart';
import 'package:frontend/timeslots/timeslots.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

/// This page should contain all the timeslots from 9 to 17.00
/// onTap on a timeslot should display either if the user wants to reserve
/// the desk at that time. If the timeslot is reserved a warning should be
/// displayed. The warning would be a popup with an ok button.
/// If the timeslot is available the popup would have to ask the user if
/// he is sure that he wants to book the tapped time
/// The system would support only one hour of booking
class TimeslotsPage extends StatelessWidget {
  const TimeslotsPage({Key? key, required this.workspaceId}) : super(key: key);

  final String workspaceId;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TimeslotRepository(),
      child: BlocProvider(
        create: (context) => TimeslotBloc(
          timeslotRepository: context.read<TimeslotRepository>(),
        )..add(GetTimeslots(workspaceId)),
        child: const TimeslotsView(),
      ),
    );
  }
}

class TimeslotsView extends StatelessWidget {
  const TimeslotsView({Key? key}) : super(key: key);

  Future<bool?> popupDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.warning),
            Text('Would you like to book?'),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          ElevatedButton(
            child: const Text('Yes'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }

  void addBooking(
    String workspaceId,
    CalendarTapDetails calendarTapDetails,
    BuildContext context,
  ) async {
    if (calendarTapDetails.appointments == null) {
      final bookResult = await popupDialog(context);
      if (bookResult != null && bookResult) {
        context.beamToNamed(
            '/home/addTimeslots/$workspaceId/${calendarTapDetails.date.toString()}');
      }
    } else if (calendarTapDetails.appointments!.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('There is already a reservation!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TimeSlots'),
      ),
      body: BlocConsumer<TimeslotBloc, TimeslotState>(
        listener: (context, state) {
          if (state is TimeslotError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          if (state is TimeslotLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TimeslotsLoaded) {
            return SfCalendar(
              onTap: (value) => addBooking(state.workspaceId, value, context),
              view: CalendarView.workWeek,
              firstDayOfWeek: 1,
              dataSource: BookingDataSource(state.timeSlots),
              timeSlotViewSettings: const TimeSlotViewSettings(
                timeIntervalHeight: 100,
                startHour: 9,
                endHour: 17,
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class BookingDataSource extends CalendarDataSource {
  BookingDataSource(List<Timeslot> source) {
    appointments = source;
  }

  Timeslot getBooking(int index) => appointments![index] as Timeslot;

  @override
  DateTime getStartTime(int index) {
    return getBooking(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return getBooking(index).to;
  }

  @override
  String getSubject(int index) {
    return getBooking(index).title;
  }
}
