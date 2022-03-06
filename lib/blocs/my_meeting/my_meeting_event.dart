part of 'my_meeting_bloc.dart';

@immutable
abstract class MyMeetingEvent {}

class MyMeetingFetchEvent extends MyMeetingEvent {
  final int startTime, endTime;

  MyMeetingFetchEvent({
    @required this.startTime,
    @required this.endTime,
  });
  @override
  String toString() {
    return 'MyMeetingFetchEvent';
  }
}

class MyMeetingIBookedFetchEvent extends MyMeetingEvent {
  final int startTime, endTime;

  MyMeetingIBookedFetchEvent({
    @required this.startTime,
    @required this.endTime,
  });

  @override
  String toString() {
    return 'MyMeetingIBookedFetchEvent';
  }
}
