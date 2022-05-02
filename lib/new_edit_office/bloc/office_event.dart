part of 'office_bloc.dart';

@immutable
abstract class OfficeEvent {
  const OfficeEvent();
}


class GetOffices extends OfficeEvent {
  const GetOffices();
}

class AddOffice extends OfficeEvent {
  const AddOffice({required this.name});

  final String name;
}

class RenameOffice extends OfficeEvent {
  const RenameOffice({required this.name});

  final String name;
}
