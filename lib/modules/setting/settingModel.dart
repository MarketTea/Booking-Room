import 'package:flutter/services.dart';
import '../../constants/key_prefs.dart';
import '../../core/routes/routeName.dart';
import '../../models/user.dart';
import '../base/baseModel.dart';
import '../../utils/asyncStorage.dart';
import 'package:flutter/cupertino.dart';

class SettingModel extends BaseModel {
  BuildContext context;
  User currentUser;

  SettingModel(this.context);

  Future<void> init() async {
    String strUser = await AsyncStorage.get(KeyPrefs.USER_PROFILE);
    currentUser = userFromJson(strUser);
    notifyListeners();
  }

  Future<void> signOut() async {
    await AsyncStorage.remove(KeyPrefs.ACCESS_TOKEN);
    await AsyncStorage.remove(KeyPrefs.USER_PROFILE);
    Navigator.of(context).pushReplacementNamed(RouteName.signIn);
  }

  Future getCodeVersion = rootBundle.loadString('assets/deploy_version.txt');
}
