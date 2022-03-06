part of 'meeting_type_bloc.dart';

@immutable
abstract class MeetingTypeState {}

class MeetingTypeInitialState extends MeetingTypeState {}

class MeetingTypeWaitingState extends MeetingTypeState {}

class MeetingTypeFetchDoneState extends MeetingTypeState {
  final List<MeetingTypeModel> lsData;

  MeetingTypeFetchDoneState(this.lsData);
}

class MeetingTypeFetchFailState extends MeetingTypeState {
  final String code;
  final String message;

  MeetingTypeFetchFailState({
    this.code,
    this.message,
  });
}

class MeetingTypeExceptionState extends MeetingTypeState {
  final String code;
  final String message;

  MeetingTypeExceptionState({
    this.code,
    this.message,
  });
}
