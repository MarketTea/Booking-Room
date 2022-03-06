import 'dart:developer';

import '../../models/notification/notification_api.dart';
import 'package:dio/dio.dart';

import '../../configs/endpoint.dart';
import '../res_util.dart';

class NotificationRes {
  final _dio = Dio();

  Future<NotificationApi> getNotification(
    int page,
  ) async {
    final header = ResUtil.getHeader();
    final res = await _dio.get(
      Endpoint.getNotification(page),
      options: Options(headers: header),
    );
    log(res?.data?.toString());
    if (res.statusCode == 200) {
      return NotificationApi.fromJson(res.data);
    }
    return null;
  }

  Future<bool> updateFcmToken(String fcmToken) async {
    final header = ResUtil.getHeader();
    final res = await _dio.post(
      Endpoint.fcmToken,
      options: Options(headers: header),
      data: {'fcm_token': '$fcmToken'},
    );
    log(res?.data?.toString());
    if (res.statusCode == 200) {
      return true;
    }
    return false;
  }
}
