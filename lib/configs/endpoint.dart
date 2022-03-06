class Endpoint {
  static const BASE_URL = 'https://cp-smart-building-dev.as.r.appspot.com';
  static const SIGN_IN = '/api/login';
  static const ROOM = '$BASE_URL/api/rooms';
  static const getAllUser = '$BASE_URL/api/users';
  static const getMeetingType = '$BASE_URL/api/meeting-types';
  static String getUserById(String id) => '$BASE_URL/api/users/$id';
  static const meeting = '$BASE_URL/api/meetings';
  static String updateMeeting(String id) => '$BASE_URL/api/meetings/$id';
  static String getNotification(int page) =>
      '$BASE_URL/api/notifications?page=$page&limit=10';
  static String getRoomDetail(String roomId) => '$BASE_URL/api/rooms/$roomId';
  static String myMeeting(
    int startTime,
    int endTime,
  ) =>
      '$BASE_URL/api/meetings/my-meetings?start_time=$startTime&end_time=$endTime';
  static meetingDetail(String id) => '$BASE_URL/api/meetings/$id';
  static const fcmToken = '$BASE_URL/api/fcm_token';
  static meetingRoom(
    String room,
    int startTime,
    int endTime,
  ) =>
      '$BASE_URL/api/meetings/room/$room?start_time=$startTime&end_time=$endTime';
  static myMeetingIBooked(
    int startTime,
    int endTime,
  ) =>
      '$BASE_URL/api/meetings/booked?start_time=$startTime&end_time=$endTime';
  static const FORGOT_PASSWORD = '';
}
