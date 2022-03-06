import 'dart:convert';
import 'dart:developer';

import '../../models/meeting/meeting_api.dart';
import '../../models/meeting/meeting_model.dart';
import '../../models/meeting/meeting_type_model.dart';
import 'package:dio/dio.dart';

import '../../configs/endpoint.dart';
import '../res_util.dart';

class MeetingRes {
  final _dio = Dio();

  /// Get all of the meetings
  Future<MeetingApi> getAllMeetings(
    String roomId,
    int startTime,
    int endTime,
  ) async {
    final header = ResUtil.getHeader();
    final res = await _dio.get(
      Endpoint.meetingRoom(roomId, startTime, endTime),
      options: Options(headers: header),
    );
    log(res?.data?.toString());
    if (res.statusCode == 200) {
      return MeetingApi.fromJson(res.data);
    }
    return null;
  }

  /// Get only my meetings
  Future<List<List<MeetingModel>>> getMyMeetings(
    int startTime,
    int endTime,
  ) async {
    try {
      final header = ResUtil.getHeader();
      final res = await _dio.get(
        Endpoint.myMeeting(startTime, endTime),
        options: Options(headers: header),
      );
      log(res?.data?.toString());
      if (res.statusCode == 200) {
        return List<List<MeetingModel>>.from(
          res.data.map(
            (x) => List<MeetingModel>.from(
              x.map((y) => MeetingModel.fromJson(y)),
            ),
          ),
        );
      }
      return null;
    } catch (err) {
      log('Has some error on getMyMeetings:\n${err.toString()}');
      return null;
    }
  }

  /// Get only my meetings I Booked
  Future<List<List<MeetingModel>>> getMyMeetingsIBooked(
      int startTime, int endTime) async {
    try {
      final header = ResUtil.getHeader();
      final res = await _dio.get(
        Endpoint.myMeetingIBooked(startTime, endTime),
        options: Options(headers: header),
      );
      log(res?.data?.toString());
      if (res.statusCode == 200) {
        return List<List<MeetingModel>>.from(
          res.data.map(
            (x) => List<MeetingModel>.from(
              x.map((y) => MeetingModel.fromJson(y)),
            ),
          ),
        );
      }
      return null;
    } catch (err) {
      log('Has some error on getMyMeetings:\n${err.toString()}');
      return null;
    }
  }

  /// Get details of the meeeting
  Future<MeetingModel> getMeetingDetail(String id) async {
    final header = ResUtil.getHeader();
    final res = await _dio.get(
      Endpoint.meetingDetail(id),
      options: Options(headers: header),
    );
    log(res?.data?.toString());
    if (res.statusCode == 200) {
      return MeetingModel.fromJson(res.data);
    }
    return null;
  }

  ///Create a new meeting
  Future<bool> createNewMeeting(MeetingModel model) async {
    try {
      final header = ResUtil.getHeader();
      final jsonData = model.toJson();
      jsonData.removeWhere((key, value) => value == null);
      final res = await _dio.post(
        Endpoint.meeting,
        data: jsonEncode(jsonData),
        options: Options(headers: header),
      );
      if (res.statusCode == 200) {
        return true;
      }
      return false;
    } catch (err) {
      log(err.toString());
      return false;
    }
  }

  ///update the new meeting
  Future<bool> updateNewMeeting(MeetingModel model) async {
    try {
      final header = ResUtil.getHeader();
      final jsonData = model.toJson();
      jsonData.removeWhere((key, value) => value == null);
      jsonData.remove('updated_time');
      jsonData.remove('created_time');
      jsonData.remove('_id');
      jsonData.remove('user_booked');
      jsonData.remove('__v');
      final res = await _dio.put(
        Endpoint.updateMeeting(model.id),
        data: jsonEncode(jsonData),
        options: Options(headers: header),
      );
      log(res.data.toString());
      if (res.statusCode == 200) {
        return true;
      }
      return false;
    } catch (err) {
      log(err.toString());
      return false;
    }
  }

  /// Get list of meeting type
  Future<List<MeetingTypeModel>> getListMeetingType() async {
    final header = ResUtil.getHeader();
    final res = await _dio.get(
      Endpoint.getMeetingType,
      options: Options(headers: header),
    );
    log(res.data.toString());
    if (res.statusCode == 200) {
      final meetingApi = MeetingTypeApi.fromJson(res.data);
      return meetingApi.data;
    }
    return [];
  }
}
