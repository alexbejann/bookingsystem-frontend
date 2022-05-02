import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bookings/bloc/booking_bloc.dart';
import 'package:frontend/timeslots/repositories/timeslot_repository.dart';

class MyBookingsPage extends StatelessWidget {
  const MyBookingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TimeslotRepository(),
      child: BlocProvider(
        create: (context) => BookingBloc(
          timeslotRepository: context.read<TimeslotRepository>(),
        )..add(const GetBookings()),
        child: const MyBookingsView(),
      ),
    );
  }
}

class MyBookingsView extends StatefulWidget {
  const MyBookingsView({Key? key}) : super(key: key);

  @override
  State<MyBookingsView> createState() => _MyBookingsViewState();
}

class _MyBookingsViewState extends State<MyBookingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
      ),
      body: BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingsError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          if (state is BookingsLoaded) {
            if (state.bookings.isEmpty) {
              return const Center(
                child: Text('There are no bookings for you!'),
              );
            }
            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                color: Colors.grey,
              ),
              shrinkWrap: true,
              itemCount: state.bookings.length,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.work),
                  title: Text(
                      'From ${state.bookings[index].from} -> To ${state.bookings[index].to}'),
                  subtitle: Text(state.bookings[index].workspaceID!.name!),
                );
              },
            );
          } else {
            return const Center(
              child: Text('Something went wrong!'),
            );
          }
        },
      ),
    );
  }
}
