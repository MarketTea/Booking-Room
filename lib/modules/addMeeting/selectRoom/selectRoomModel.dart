import '../../base/baseModel.dart';
import '../../../widgets/selectRoomTile.dart';

class SelectRoomModel extends BaseModel {
  List<SelectRoomItem> items = [
    /* SelectRoomItem(
        name: 'Phòng họp 1',
        description: '20 người, máy chiếu, đèn',
        selected: true),
    SelectRoomItem(
        name: 'Phòng họp 2', description: '8 người', selected: false), */
  ];

  void onChangedSelectItem(int index, bool value) {
    for (int i = 0; i < items.length; i++) {
      if (i == index) {
        items[i].selected = value;
      } else {
        items[i].selected = false;
      }
    }
    notifyListeners();
  }
}
