part of 'booking_bloc.dart';

@immutable
abstract class BookingEvent {
  const BookingEvent();
}

class GetBookings extends BookingEvent{
  const GetBookings();
}

class DeleteBooking extends BookingEvent {
  const DeleteBooking(this.timeslotId);
  final String timeslotId;
}
