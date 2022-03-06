import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import '../../models/meeting/meeting_model.dart';
import '../../repositories/meeting/meeting_res.dart';
import 'package:meta/meta.dart';

part 'my_meeting_event.dart';
part 'my_meeting_state.dart';

class MyMeetingBloc extends Bloc<MyMeetingEvent, MyMeetingState> {
  MyMeetingBloc() : super(MyMeetingInitialState());

  @override
  Stream<MyMeetingState> mapEventToState(
    MyMeetingEvent event,
  ) async* {
    try {
      if (event is MyMeetingFetchEvent) {
        yield MyMeetingWaitingState();
        final res =
            await MeetingRes().getMyMeetings(event.startTime, event.endTime);
        if (res != null) {
          yield MyMeetingFetchDoneState(res);
        } else {
          yield MyMeetingFetchFailState(message: 'Lỗi không xác định');
        }
      } else if (event is MyMeetingIBookedFetchEvent) {
        yield MyMeetingWaitingState();
        final res = await MeetingRes()
            .getMyMeetingsIBooked(event.startTime, event.endTime);
        if (res != null) {
          yield MyMeetingFetchDoneState(res);
        } else {
          yield MyMeetingFetchFailState(message: 'Lỗi không xác định');
        }
      }
    } catch (err) {
      log(err.toString());
      yield MyMeetingExceptionState(message: 'Lỗi không xác định');
    }
  }
}
