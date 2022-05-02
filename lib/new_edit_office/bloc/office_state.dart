part of 'office_bloc.dart';

@immutable
abstract class OfficeState {
  const OfficeState();
}

class OfficeInitial extends OfficeState {}

class OfficeLoading extends OfficeState {
  const OfficeLoading();
}

class OfficeLoaded extends OfficeState {
  const OfficeLoaded(this.offices);

  final List<Office> offices;
}

class SavedOffice extends OfficeState {

  const SavedOffice({required this.office});

  final Office office;
}

class OfficeError extends OfficeState {
  const OfficeError(this.error);
  final String error;
}
