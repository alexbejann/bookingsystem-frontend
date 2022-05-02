import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:frontend/app/bloc/authentication_bloc.dart';
import 'package:frontend/app/model/workspace.dart';
import 'package:frontend/bookings/bookings.dart';
import 'package:frontend/chat_admin/chat_admin.dart';
import 'package:frontend/home/bloc/workspace_bloc.dart';
import 'package:frontend/home/repositories/workspace_repository.dart';
import 'package:frontend/l10n/l10n.dart';
import 'package:frontend/new_edit_office/new_edit_office.dart';
import 'package:frontend/new_edit_workspace/new_edit_workspace.dart';
import 'package:frontend/timeslots/timeslots.dart';
import 'package:grouped_list/grouped_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => WorkspaceRepository(),
      child: BlocProvider(
        create: (context) => WorkspaceBloc(
          workspaceRepository: context.read<WorkspaceRepository>(),
        ),
        child: const HomeView(),
      ),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  void deleteWorkspace() {
    //todo delete workspace with a popup for confirmation
  }

  Future<void> _optionMenu(BuildContext context) async {
    await showModalBottomSheet<dynamic>(
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('My bookings'),
              onTap: () => context.beamToNamed('/home/bookings'),
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Chat Admin'),
              onTap: () => context.beamToNamed('/home/chatAdmin'),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: context.read<AuthenticationBloc>().logout,
            ),
          ],
        );
      },
    );
  }

  Future<void> _settingModalBottomSheet(BuildContext context) async {
    await showModalBottomSheet<dynamic>(
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add office'),
              onTap: () =>
                  context.beamToNamed('/home/newEditOffice?isNew=true'),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Rename office'),
              onTap: () =>
                  context.beamToNamed('/home/newEditOffice?isNew=false'),
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever),
              title: const Text('Delete office'),
              onTap: deleteWorkspace,
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<WorkspaceBloc>().add(const GetWorkspaces());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          return Visibility(
            /// Limited functionality to admin user
            visible: state.user.admin,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).bottomAppBarColor,
              onPressed: () =>
                  context.beamToNamed('/home/newEditWorkspace'),
              child: const Icon(
                Icons.add,
              ),
            ),
          );
        },
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      bottomNavigationBar: BottomAppBar(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () async {
                  await _optionMenu(context);
                },
              ),
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  return Visibility(
                    /// Limited functionality to admin user
                    visible: state.user.admin,
                    child: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () async {
                        await _settingModalBottomSheet(context);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Desk Booking'),
      ),
      body: BlocConsumer<WorkspaceBloc, WorkspaceState>(
        listener: (context, state) {
          if (state is WorkspaceError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          } else if (state is DeletedWorkspace) {
            context.read<WorkspaceBloc>().add(const GetWorkspaces());
          }
        },
        builder: (context, state) {
          if (state is WorkspaceLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WorkspaceLoaded) {
            return GroupedListView<Workspace, String>(
              elements: state.workspaces,
              groupBy: (element) => element.office!.name,
              groupSeparatorBuilder: (value) => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Text(value),
              ),
              useStickyGroupSeparators: true, // optional
              itemBuilder: (context, element) {
                return Card(
                  child: Slidable(
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (BuildContext context) {
                            context
                                .read<WorkspaceBloc>()
                                .add(DeleteWorkspace(element.id));
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                        SlidableAction(
                          onPressed: (BuildContext context) =>
                              context.beamToNamed(
                            '/home/newEditWorkspace?workspace=${element.id}&name=${element.name}',
                          ),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.work),
                      title: Text(element.name!),
                      onTap: () =>
                          context..beamToNamed('/home/timeslots/${element.id}'),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
