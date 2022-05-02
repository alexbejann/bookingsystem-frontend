part of 'edit_workspace_bloc.dart';

@immutable
abstract class EditWorkspaceEvent {
  const EditWorkspaceEvent();
}

class RenameWorkspace extends EditWorkspaceEvent {
  const RenameWorkspace({required this.name, required this.id});

  final String name;
  final String id;
}

class CreateWorkspace extends EditWorkspaceEvent {
  const CreateWorkspace({required this.name, required this.officeId});

  final String name;
  final String officeId;
}

class GetOffices extends EditWorkspaceEvent {

  const GetOffices();
}

class SaveWorkspace extends EditWorkspaceEvent {

  const SaveWorkspace({required this.name, required this.id});

  final String name;
  final String id;
}
