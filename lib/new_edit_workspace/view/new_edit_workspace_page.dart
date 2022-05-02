import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/app/model/office.dart';
import 'package:frontend/home/repositories/workspace_repository.dart';
import 'package:frontend/new_edit_office/repositories/office_repository.dart';
import 'package:frontend/new_edit_workspace/bloc/edit_workspace_bloc.dart';

class NewEditWorkspacePage extends StatelessWidget {
  const NewEditWorkspacePage({Key? key, this.workspaceName, this.workspaceId})
      : super(key: key);

  final String? workspaceName;
  final String? workspaceId;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<OfficeRepository>(
          create: (context) => OfficeRepository(),
        ),
        RepositoryProvider<WorkspaceRepository>(
          create: (context) => WorkspaceRepository(),
        ),
      ],
      child: BlocProvider(
        create: (context) => EditWorkspaceBloc(
          officeRepository: context.read<OfficeRepository>(),
          workspaceRepository: context.read<WorkspaceRepository>(),
        )..add(const GetOffices()),
        child: NewEditWorkspaceView(
          workspaceId: workspaceId,
          workspaceName: workspaceName,
        ),
      ),
    );
  }
}

class NewEditWorkspaceView extends StatefulWidget {
  NewEditWorkspaceView({
    Key? key,
    this.workspaceName,
    this.workspaceId,
  }) : super(key: key);

  final String? workspaceName;
  final String? workspaceId;

  @override
  State<NewEditWorkspaceView> createState() => _NewEditWorkspaceViewState();
}

class _NewEditWorkspaceViewState extends State<NewEditWorkspaceView> {
  late TextEditingController _oldListTitleController;

  final workspaceNameController = TextEditingController();

  String? officeId;

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode()..requestFocus();
    _oldListTitleController = TextEditingController(
      text: widget.workspaceName ?? 'Create a new Workspace',
    );
    return Scaffold(
      body: BlocListener<EditWorkspaceBloc, EditWorkspaceState>(
        listener: (context, state) {
          if (state is SavedWorkspace) {
            Navigator.of(context).maybePop();
          }
        },
        child: ListView(
          children: [
            ListTile(
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
              title: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.workspaceId == null
                      ? 'Create new workspace'
                      : 'Edit workspace',
                ),
                autofocus: true,
                enabled: true,
                controller: _oldListTitleController,
              ),
              trailing: TextButton(
                onPressed: () {
                  // bloc office add/edit
                  if (workspaceNameController.text.isNotEmpty &&
                      widget.workspaceId != null) {
                    context.read<EditWorkspaceBloc>().add(
                          RenameWorkspace(
                            name: workspaceNameController.text,
                            id: widget.workspaceId!,
                          ),
                        );
                  } else {
                    context.read<EditWorkspaceBloc>().add(
                          CreateWorkspace(
                            name: workspaceNameController.text,
                            officeId: officeId!,
                          ),
                        );
                  }
                },
                child: const Text('Done'),
              ),
            ),
            const Divider(),
            ListTile(
              title: TextField(
                focusNode: focusNode,
                controller: workspaceNameController,
                decoration:
                    const InputDecoration(labelText: 'Enter workspace name'),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const Divider(),
            Visibility(
              visible: widget.workspaceId == null,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BlocBuilder<EditWorkspaceBloc, EditWorkspaceState>(
                  builder: (context, state) {
                    if (state is OfficesLoaded) {
                      return DropdownButton<String>(
                        hint: const Text('Please choose an office'),
                        value: officeId,
                        items: state.offices.map((Office office) {
                          return DropdownMenuItem<String>(
                            value: office.id,
                            child: Text(office.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            officeId = value;
                          });
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
