import '../../base/baseModel.dart';
import '../../../widgets/selectParticipantTitle.dart';

class SelectParticipantModel extends BaseModel {
  List<SelectParticipantItem> items = [];

  void onChangedSelectItem(SelectParticipantItem item, bool value) {
    items.firstWhere((e) => e.id == item.id).selected = value;
    notifyListeners();
  }
}
