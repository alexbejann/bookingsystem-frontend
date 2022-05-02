part of 'booking_bloc.dart';

@immutable
abstract class BookingState {

  const BookingState();
}

class BookingInitial extends BookingState {

  const BookingInitial();
}

class BookingsLoaded extends BookingState {

  const BookingsLoaded(this.bookings);
  final List<Timeslot> bookings;
}

class BookingsError extends BookingState {

  const BookingsError(this.error);
  final String error;
}
