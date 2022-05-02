part of 'workspace_bloc.dart';

@immutable
abstract class WorkspaceState {
  const WorkspaceState();
}

class WorkspaceInitial extends WorkspaceState {
  const WorkspaceInitial();
}

class WorkspaceLoading extends WorkspaceState {
  const WorkspaceLoading();
}

class WorkspaceLoaded extends WorkspaceState {
  const WorkspaceLoaded(this.workspaces);

  final List<Workspace> workspaces;
}

class WorkspaceError extends WorkspaceState {
  const WorkspaceError(this.error);
  final String error;
}

class DeletedWorkspace extends WorkspaceState {
  const DeletedWorkspace(this.workspace);
  final Workspace workspace;
}

