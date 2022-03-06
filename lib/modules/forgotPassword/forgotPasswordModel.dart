import '../../constants/constant.dart';
import '../../models/reqres/forgotPassword.dart';
import '../base/baseModel.dart';
import '../../services/authService.dart';
import '../../utils/toast.dart';
import 'package:flutter/material.dart';

class ForgotPasswordModel extends BaseModel {
  final AuthService _authService = AuthService.instance();
  BuildContext context;
  String email;

  ForgotPasswordModel(this.context);

  Future<void> forgotPassword() async {
    setLoading(true);
    try {
      ForgotPasswordRes res =
          await _authService.forgotPassword(ForgotPasswordReq(email: email));
      if (res.status == 200) {
        Toast.success(message: Constant.success);
      } else {
        Toast.error(message: Constant.failure);
      }
    } catch (e) {
      print(e.toString());
      if (e.response.statusCode == 400) {
        Toast.error(message: 'Email của bạn không đúng, vui lòng thử lại');
      } else {
        Toast.error(message: 'Lỗi hệ thống');
      }
    } finally {
      setLoading(false);
    }
  }
}
