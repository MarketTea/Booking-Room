import 'dart:io';

import '../services/io.dart';
import '../services/share_pref_name.dart';

class ResUtil {
  static Map<String, dynamic> getHeader() {
    final token = IO.getString(SharedPrefsName.token, defValue: '');
    if (token == '') {
      return {
        HttpHeaders.contentTypeHeader: 'application/json',
      };
    } else {
      return {
        'x-auth-token': token,
        HttpHeaders.contentTypeHeader: 'application/json',
      };
    }
  }
}
