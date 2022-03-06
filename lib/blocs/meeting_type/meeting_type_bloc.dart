import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import '../../models/meeting/meeting_type_model.dart';
import '../../repositories/meeting/meeting_res.dart';
import 'package:meta/meta.dart';

part 'meeting_type_event.dart';
part 'meeting_type_state.dart';

class MeetingTypeBloc extends Bloc<MeetingTypeEvent, MeetingTypeState> {
  MeetingTypeBloc() : super(MeetingTypeInitialState());

  @override
  Stream<MeetingTypeState> mapEventToState(
    MeetingTypeEvent event,
  ) async* {
    try {
      if (event is MeetingTypeFetchEvent) {
        yield MeetingTypeWaitingState();
        final res = await MeetingRes().getListMeetingType();
        if (res != null) {
          yield MeetingTypeFetchDoneState(res);
        } else {
          yield MeetingTypeFetchFailState(message: 'Lỗi không xác định');
        }
      }
    } catch (err) {
      log(err.toString());
      yield MeetingTypeExceptionState(message: 'Lỗi không xác định');
    }
  }
}
