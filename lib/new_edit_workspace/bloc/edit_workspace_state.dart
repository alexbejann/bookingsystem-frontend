part of 'edit_workspace_bloc.dart';

@immutable
abstract class EditWorkspaceState {

  const EditWorkspaceState();
}

class EditWorkspaceInitial extends EditWorkspaceState {

  const EditWorkspaceInitial();
}

class OfficesLoaded extends EditWorkspaceState {

  const OfficesLoaded(this.offices);

  final List<Office> offices;
}

class SavedWorkspace extends EditWorkspaceState {

  const SavedWorkspace(this.workspace);

  final Workspace workspace;
}
