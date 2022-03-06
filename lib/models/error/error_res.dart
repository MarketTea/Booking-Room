// To parse this JSON data, do
//
//     final errorRes = errorResFromJson(jsonString);

import 'dart:convert';

ErrorRes errorResFromJson(String str) => ErrorRes.fromJson(json.decode(str));

String errorResToJson(ErrorRes data) => json.encode(data.toJson());

class ErrorRes {
  ErrorRes({
    this.errorCode,
    this.errorMessage,
  });

  String errorCode;
  String errorMessage;

  factory ErrorRes.fromJson(Map<String, dynamic> json) => ErrorRes(
        errorCode: json["error_code"] == null ? null : json["error_code"],
        errorMessage:
            json["error_message"] == null ? null : json["error_message"],
      );

  Map<String, dynamic> toJson() => {
        "error_code": errorCode == null ? null : errorCode,
        "error_message": errorMessage == null ? null : errorMessage,
      };
}
