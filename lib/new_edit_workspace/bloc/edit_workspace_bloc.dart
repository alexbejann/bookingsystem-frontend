import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:frontend/app/model/office.dart';
import 'package:frontend/app/model/workspace.dart';
import 'package:frontend/home/repositories/workspace_repository.dart';
import 'package:frontend/new_edit_office/repositories/office_repository.dart';
import 'package:meta/meta.dart';

part 'edit_workspace_event.dart';
part 'edit_workspace_state.dart';

class EditWorkspaceBloc extends Bloc<EditWorkspaceEvent, EditWorkspaceState> {
  EditWorkspaceBloc({
    required this.officeRepository,
    required this.workspaceRepository,
  }) : super(const EditWorkspaceInitial()) {
    on<GetOffices>(
      (event, emit) async =>
          emit(OfficesLoaded(await officeRepository.getOffices())),
    );

    on<RenameWorkspace>(
      (event, emit) async => emit(
        SavedWorkspace(
          await workspaceRepository.renameWorkspace(
            workspaceName: event.name,
            workspaceId: event.id,
          ),
        ),
      ),
    );

    on<CreateWorkspace>(
      (event, emit) async => emit(
        SavedWorkspace(
          await workspaceRepository.createWorkspace(
            workspaceName: event.name,
            officeId: event.officeId,
          ),
        ),
      ),
    );
  }

  final OfficeRepository officeRepository;
  final WorkspaceRepository workspaceRepository;
}
