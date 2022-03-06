import '../../configs/config.dart';
import '../../core/locales/i18nKey.dart';
import '../../models/meeting/meeting_model.dart';
import '../../models/meeting/meeting_type_model.dart';
import '../base/baseModel.dart';
import '../../repositories/room/room_res.dart';
import '../../widgets/orderRoomTile.dart';
import 'package:flutter/cupertino.dart';

class AddMeetingModel extends BaseModel {
  BuildContext context;

  MeetingModel model;
  String dropdownValue;
  List<MeetingTypeModel> dropdownList = [];

  void onDropdownChanged(String value) {
    dropdownValue = value;
    model.type = value;
    notifyListeners();
  }

  void updateMeetingType(List<MeetingTypeModel> ls) {
    dropdownList.clear();
    dropdownList.addAll(ls);
    notifyListeners();
  }

  _getRepeatString(int i) {
    switch (i) {
      case 1:
        return 'Hàng ngày';
      case 2:
        return 'Hàng tuần';
      case 3:
        return 'Hàng tháng';
      case 4:
        return 'Hàng năm';
      default:
        return 'Không bao giờ';
    }
  }

  init({MeetingModel initModel}) async {
    if (initModel != null) {
      model = initModel;
      updateStart(
          DateTime.fromMillisecondsSinceEpoch(initModel?.startTime ?? 0));
      updateEnd(DateTime.fromMillisecondsSinceEpoch(initModel?.endTime ?? 0));
      RoomRes().getRoomDetail(initModel.room as String).then((room) {
        if (room != null) {
          updateRoom(room?.name ?? '');
        }
      });
      updaterepeat(_getRepeatString(initModel?.repeat ?? 0));
      updateMember(initModel?.members?.length ?? 0);
    } else {
      model = MeetingModel();
      model.repeat = 0;
      updaterepeat(_getRepeatString(0));
    }
  }

  AddMeetingModel(
    this.context,
  );

  List<String> data = [
    'Chưa chọn',
    '--/--/----, 00:00',
    '--/--/----, 00:00',
    'Chưa chọn',
    '0'
  ];

  void updateStart(DateTime start) {
    data[1] = AppConfig.dateFormat2.format(start);
    model.startTime = start.millisecondsSinceEpoch;
    notifyListeners();
  }

  void updateEnd(DateTime end) {
    data[2] = AppConfig.dateFormat2.format(end);
    model.endTime = end.millisecondsSinceEpoch;
    notifyListeners();
  }

  void updateRoom(String roomName) {
    data[0] = roomName;
    notifyListeners();
  }

  void updateMember(int numMem) {
    data[4] = numMem.toString();
    notifyListeners();
  }

  void updaterepeat(String repeat) {
    data[3] = repeat;
    notifyListeners();
  }

  List<OrderRoomItem> items = [
    OrderRoomItem(
      title: I18nKey.meetingRoom,
    ),
    OrderRoomItem(
      title: I18nKey.start,
    ),
    OrderRoomItem(
      title: I18nKey.end,
    ),
    OrderRoomItem(
      title: I18nKey.repeat,
    ),
    OrderRoomItem(
      title: I18nKey.participant,
    ),
  ];
}
