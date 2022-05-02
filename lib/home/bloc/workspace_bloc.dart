import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:frontend/app/model/office.dart';
import 'package:frontend/app/model/workspace.dart';
import 'package:frontend/home/home.dart';
import 'package:frontend/home/repositories/workspace_repository.dart';
import 'package:meta/meta.dart';

part 'workspace_event.dart';
part 'workspace_state.dart';

// WorkspaceLoaded([Workspace(name: 'worksapce1', office: Office('Office1')),
// Workspace(name: 'worksapce2', office: Office('Office2')),
// Workspace(name: 'worksapce2', office: Office('Office2')),
// Workspace(name: 'worksapce3', office: Office('Office1'))])
class WorkspaceBloc extends Bloc<WorkspaceEvent, WorkspaceState> {
  WorkspaceBloc({required this.workspaceRepository})
      : super(const WorkspaceInitial()) {
    on<GetWorkspaces>(
      (event, emit) async =>
          emit(WorkspaceLoaded(await workspaceRepository.getWorkspaces())),
    );

    on<DeleteWorkspace>(
      (event, emit) async => emit(
        DeletedWorkspace(
          await workspaceRepository.deleteWorkspace(
            workspaceId: event.id,
          ),
        ),
      ),
    );
  }

  final WorkspaceRepository workspaceRepository;
}
