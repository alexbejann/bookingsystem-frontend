part of 'workspace_bloc.dart';

@immutable
abstract class WorkspaceEvent {
  const WorkspaceEvent();
}


class GetWorkspaces extends WorkspaceEvent {
  const GetWorkspaces();
}

class GetWorkspace extends WorkspaceEvent {
  const GetWorkspace(this.workspaceName);

  final String workspaceName;
}

class RenameWorkspace extends WorkspaceEvent {
  const RenameWorkspace(this.newWorkspaceName, );

  final String newWorkspaceName;
}

class WorkspaceEdited extends WorkspaceEvent {
  const WorkspaceEdited(this.workspace);

  final Workspace workspace;
}

class DeleteWorkspace extends WorkspaceEvent {
  const DeleteWorkspace(this.id);

  final String id;
}
