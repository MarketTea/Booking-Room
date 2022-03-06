import '../../constants/constant.dart';
import '../../services/controlService.dart';
import '../../utils/toast.dart';
import 'package:dio/dio.dart';

import '../../constants/key_prefs.dart';
import '../../models/user.dart';
import '../base/baseModel.dart';
import '../../utils/asyncStorage.dart';
import 'package:flutter/cupertino.dart';

class EditPasswordModel extends BaseModel {
  ControlService _controlService = ControlService.instance();
  BuildContext context;
  User currentUser;

  EditPasswordModel(this.context);

  Future<void> init() async {
    String strUser = await AsyncStorage.get(KeyPrefs.USER_PROFILE);
    currentUser = userFromJson(strUser);
    notifyListeners();
  }

  Future<void> editPassword({
    Map<String, dynamic> params,
    Function(String) onError,
    BuildContext context,
  }) async {
    setLoading(true);
    try {
      Response<dynamic> response = await _controlService.editPassword(params);
      if (response.statusCode == 200) {
        Toast.success(message: Constant.success);
      } else {
        onError(response.data.toString());
      }
      notifyListeners();
    } catch (e) {
      onError(e.response.data['error_message'].toString());
    } finally {
      setLoading(false);
    }
  }
}
