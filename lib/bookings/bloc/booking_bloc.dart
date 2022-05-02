import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:frontend/app/model/timeslot.dart';
import 'package:frontend/timeslots/repositories/timeslot_repository.dart';
import 'package:meta/meta.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc({required this.timeslotRepository})
      : super(const BookingInitial()) {
    on<GetBookings>((event, emit) async => _handleBookingLoading(event, emit));
  }
  final TimeslotRepository timeslotRepository;
  Future<void> _handleBookingLoading(
      GetBookings event, Emitter<BookingState> emit,) async {
    emit(BookingsLoaded(await timeslotRepository.getBookings()));
  }
}
