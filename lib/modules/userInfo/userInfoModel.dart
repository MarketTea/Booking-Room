import '../../constants/key_prefs.dart';
import '../../models/user.dart';
import '../base/baseModel.dart';
import '../../utils/asyncStorage.dart';
import 'package:flutter/cupertino.dart';

class UserInfoModel extends BaseModel {
  BuildContext context;
  User currentUser;

  UserInfoModel(this.context);

  Future<void> init() async {
    String strUser = await AsyncStorage.get(KeyPrefs.USER_PROFILE);
    currentUser = userFromJson(strUser);
    notifyListeners();
  }
}
