part of 'room_bloc.dart';

@immutable
abstract class RoomEvent {}

class RoomFetchEvent extends RoomEvent {}

class RoomChangeTabEvent extends RoomEvent {
  final String roomId;

  RoomChangeTabEvent(this.roomId);
}
