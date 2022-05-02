import 'package:bloc/bloc.dart';
import 'package:frontend/app/model/timeslot.dart';
import 'package:frontend/timeslots/repositories/timeslot_repository.dart';
import 'package:meta/meta.dart';

part 'add_timeslot_event.dart';
part 'add_timeslot_state.dart';

class AddTimeslotBloc extends Bloc<AddTimeslotEvent, AddTimeslotState> {
  AddTimeslotBloc({
    required this.timeslotRepository,
    required DateTime from,
    required DateTime to,
    required this.workspaceId,
  }) : super(
          AddTimeslotInitial(
            from: from,
            to: to,
          ),
        ) {
    on<SaveTimeslot>(
      (event, emit) async {
        try {
          emit(
            SavedTimeslot(
              timeslot: await timeslotRepository.addTimeslot(
                variables: <String, dynamic>{
                  'workspaceId': workspaceId,
                  'from': event.from.millisecondsSinceEpoch.toString(),
                  'to': event.to.millisecondsSinceEpoch.toString(),
                },
              ),
            ),
          );
        } catch (e) {
          emit(SaveTimeslotFailure(e.toString()));
        }
      },
    );
  }

  final TimeslotRepository timeslotRepository;
  final String workspaceId;
}
