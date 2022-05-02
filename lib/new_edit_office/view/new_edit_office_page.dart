import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/app/model/office.dart';
import 'package:frontend/new_edit_office/new_edit_office.dart';
import 'package:frontend/new_edit_office/repositories/office_repository.dart';

class NewEditOfficePage extends StatelessWidget {
  const NewEditOfficePage({Key? key, this.isNewOffice = false})
      : super(key: key);
  final bool isNewOffice;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => OfficeRepository(),
      child: BlocProvider(
        create: (context) => OfficeBloc(
          officeRepository: context.read<OfficeRepository>(),
        ),
        child: NewEditOfficeView(isNewOffice: isNewOffice,),
      ),
    );
  }
}

class NewEditOfficeView extends StatelessWidget {
  NewEditOfficeView({Key? key, this.isNewOffice = false}) : super(key: key);
  final bool isNewOffice;
  final _formKey = GlobalKey<FormState>();
  final officeNameController = TextEditingController();

  void saveForm(BuildContext context) {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      isNewOffice
          ? context.read<OfficeBloc>().add(
                RenameOffice(
                  name: officeNameController.text,
                ),
              )
          : context.read<OfficeBloc>().add(
                RenameOffice(
                  name: officeNameController.text,
                ),
              );
    }
  }

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode()..requestFocus();
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            ListTile(
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
              title: Text(
                isNewOffice ? 'Create new office' : 'Edit office',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              trailing: TextButton(
                onPressed: () => saveForm(context),
                child: const Text('Done'),
              ),
            ),
            const Divider(),
            ListTile(
              title: TextField(
                controller: officeNameController,
                focusNode: focusNode,
                decoration:
                    const InputDecoration(labelText: 'Enter office name'),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const Divider(),
            Visibility(
              visible: isNewOffice == false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BlocBuilder<OfficeBloc, OfficeState>(
                  builder: (context, state) {
                    if (state is OfficeLoaded) {
                      return DropdownButton<String>(
                        hint: const Text('Please choose an office'),
                        items: state.offices.map((Office office) {
                          return DropdownMenuItem<String>(
                            value: office.id,
                            child: Text(office.name),
                          );
                        }).toList(),
                        onChanged: (_) {},
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
