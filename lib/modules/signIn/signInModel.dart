import '../../constants/constant.dart';
import '../../constants/key_prefs.dart';
import '../../core/routes/routeName.dart';
import '../../models/reqres/signIn.dart';
import '../../models/user.dart';
import '../base/baseModel.dart';
import '../../services/authService.dart';
import '../../utils/asyncStorage.dart';
import '../../utils/toast.dart';
import 'package:flutter/material.dart';

class SignInModel extends BaseModel {
  final AuthService _authService = AuthService.instance();
  BuildContext context;

  // String email = 'admin@gmail.com';
  // String password = 'admin@admin';
  String email = '';
  String password = '';

  SignInModel(this.context);

  Future<void> signIn({
    Function onError,
  }) async {
    setLoading(true);
    try {
      SignInRes res = await _authService
          .signIn(SignInReq(email: email, password: password));
      if (res.status == 200) {
        Toast.success(message: Constant.success);
        await AsyncStorage.set(KeyPrefs.ACCESS_TOKEN, res.message);
        await AsyncStorage.set(KeyPrefs.USER_PROFILE, userToJson(res.data));
        Navigator.of(context).pushReplacementNamed(RouteName.home);
      } else {
        Toast.error(message: Constant.failure);
      }
    } catch (e) {
      if (e.response.statusCode == 400) {
        onError('Email hoặc mật khẩu của bạn không đúng, vui lòng thử lại');
      } else {
        onError(e.toString());
      }
    } finally {
      setLoading(false);
    }
  }
}


