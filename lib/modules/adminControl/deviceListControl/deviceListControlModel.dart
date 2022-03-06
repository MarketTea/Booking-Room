import '../../../constants/constant.dart';
import '../../../models/control/device.dart';
import '../../base/baseModel.dart';
import '../../../services/controlService.dart';
import '../../../utils/toast.dart';

class DeviceListControlModel extends BaseModel {
  ControlService _controlService = ControlService.instance();
  List<Device> list = [];

  Future<void> getDeviceList(String roomId) async {
    setLoading(true);
    try {
      List<Device> devices = (await _controlService.getDeviceList(roomId)).data;
      list = devices;
      notifyListeners();
    } catch (error) {
      Toast.error(message: Constant.failure);
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateDevice(String deviceId, {bool isOn, int value}) async {
    setLoading(true);
    try {
      await _controlService.updateDevice(deviceId, isOn: isOn, value: value);
      Toast.success(message: Constant.success);
    } catch (error) {
      Toast.error(message: Constant.failure);
    } finally {
      setLoading(false);
    }
  }
}
