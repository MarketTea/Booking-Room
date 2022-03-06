import '../base/baseModel.dart';
// import '../../widgets/meetingTile.dart';
import '../../widgets/timelineTile.dart';

class MyMeetingModel extends BaseModel {
  int currentTab = 0;
  List<TimelineItem> items = [
    /*TimelineItem(time: 'Thứ 2, 28/6', data: [
       MeetingItem(
          start: '12:15', end: '13:15', title: 'cuộc họp 1', room: 'phòng 1')
    ]),
    TimelineItem(time: 'Thứ 2, 28/6', data: [
      MeetingItem(
          start: '12:15', end: '13:15', title: 'cuộc họp 1', room: 'phòng 1')
    ]),
    TimelineItem(time: 'Thứ 2, 28/6', data: [
      MeetingItem(
          start: '12:15', end: '13:15', title: 'cuộc họp 1', room: 'phòng 1'),
      MeetingItem(
          start: '12:15', end: '13:15', title: 'cuộc họp 1', room: 'phòng 1'),
      MeetingItem(
          start: '12:15', end: '13:15', title: 'cuộc họp 1', room: 'phòng 1')
    ]),
    TimelineItem(time: 'Thứ 2, 28/6', data: [
      MeetingItem(
          start: '12:15', end: '13:15', title: 'cuộc họp 1', room: 'phòng 1')
    ]),
    TimelineItem(time: 'Thứ 2, 28/6', data: [
      MeetingItem(
          start: '12:15', end: '13:15', title: 'cuộc họp 1', room: 'phòng 1')
    ]) */
  ];

  void changeTab(int value) {
    if (value == currentTab) return;
    currentTab = value;
    notifyListeners();
  }
}
