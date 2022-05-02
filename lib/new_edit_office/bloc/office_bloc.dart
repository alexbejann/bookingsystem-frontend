import 'package:bloc/bloc.dart';
import 'package:frontend/app/model/office.dart';
import 'package:frontend/new_edit_office/repositories/office_repository.dart';
import 'package:meta/meta.dart';

part 'office_event.dart';
part 'office_state.dart';

class OfficeBloc extends Bloc<OfficeEvent, OfficeState> {
  OfficeBloc({required this.officeRepository}) : super(OfficeInitial()) {
    on<GetOffices>(
      (event, emit) async =>
          emit(OfficeLoaded(await officeRepository.getOffices())),
    );

    on<RenameOffice>(
      (event, emit) async => emit(
        SavedOffice(
          office: await officeRepository.addOffice(
            variables: <String, dynamic>{
              'name': event.name,
            },
          ),
        ),
      ),
    );

    on<AddOffice>(
          (event, emit) async => emit(
        SavedOffice(
          office: await officeRepository.renameOffice(
            variables: <String, dynamic>{
              'name': event.name,
            },
          ),
        ),
      ),
    );
  }

  final OfficeRepository officeRepository;
}
