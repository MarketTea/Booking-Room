import '../../../constants/constant.dart';
import '../../../models/control/room.dart';
import '../../base/baseModel.dart';
import '../../../services/controlService.dart';
import '../../../utils/toast.dart';

class RoomListControlModel extends BaseModel {
  ControlService _controlService = ControlService.instance();
  List<Room> list = [];

  Future<void> getRoomList() async {
    setLoading(true);
    try {
      List<Room> rooms = (await _controlService.getRoomList()).data;
      rooms.sort((a, b) => a.name.compareTo(b.name));
      list = rooms;
      notifyListeners();
    } catch (error) {
      Toast.error(message: Constant.failure);
    } finally {
      setLoading(false);
    }
  }
}
