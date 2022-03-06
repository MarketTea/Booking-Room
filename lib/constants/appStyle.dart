import 'package:flutter/material.dart';
import 'appColor.dart';

class AppStyle {
  static const TextStyle h1 = TextStyle(
      fontSize: 22, color: AppColor.black, fontWeight: FontWeight.bold);
  static const TextStyle h2 = TextStyle(
      fontSize: 20, color: AppColor.black, fontWeight: FontWeight.bold);
  static const TextStyle h3 = TextStyle(
      fontSize: 18, color: AppColor.black, fontWeight: FontWeight.bold);
  static const TextStyle h4 = TextStyle(
      fontSize: 16, color: AppColor.black, fontWeight: FontWeight.bold);
  static const TextStyle h5 = TextStyle(
      fontSize: 14, color: AppColor.black, fontWeight: FontWeight.bold);

  static const TextStyle h0White =
      TextStyle(fontSize: 30, color: AppColor.white);
  static const TextStyle h1White = TextStyle(
      fontSize: 22, color: AppColor.white, fontWeight: FontWeight.bold);
  static const TextStyle h2White = TextStyle(
      fontSize: 20, color: AppColor.white, fontWeight: FontWeight.bold);
  static const TextStyle h3White = TextStyle(
      fontSize: 18, color: AppColor.white, fontWeight: FontWeight.bold);
  static const TextStyle h4White = TextStyle(
      fontSize: 16, color: AppColor.white, fontWeight: FontWeight.bold);

  static const TextStyle title1 =
      TextStyle(fontSize: 18, color: AppColor.black);
  static const TextStyle title1White =
      TextStyle(fontSize: 18, color: AppColor.white);
  static TextStyle title1Secondary =
      TextStyle(fontSize: 18, color: AppColor.secondary);
  static TextStyle title1Primary =
      TextStyle(fontSize: 18, color: AppColor.primary);

  static TextStyle title2 = TextStyle(fontSize: 16, color: AppColor.primary);
  static const TextStyle title2White =
      TextStyle(fontSize: 16, color: AppColor.white);
  static TextStyle title2Secondary =
      TextStyle(fontSize: 16, color: AppColor.secondary);
  static TextStyle title2Primary =
      TextStyle(fontSize: 16, color: AppColor.primary);

  static const TextStyle title3 =
      TextStyle(fontSize: 14, color: AppColor.black);
  static const TextStyle title3White =
      TextStyle(fontSize: 14, color: AppColor.white);
  static TextStyle title3Secondary =
      TextStyle(fontSize: 14, color: AppColor.secondary);
  static TextStyle title3Primary =
      TextStyle(fontSize: 14, color: AppColor.primary);

  static TextStyle subtitle1 =
      TextStyle(fontSize: 14, color: AppColor.secondary);
  static TextStyle subtitle2 =
      TextStyle(fontSize: 12, color: AppColor.secondary);
  static TextStyle subtitle1Light =
      TextStyle(fontSize: 14, color: AppColor.subTitle);
  static TextStyle subtitle1White =
      TextStyle(fontSize: 14, color: AppColor.white.withOpacity(0.6));
  static const TextStyle subtitle3 =
      TextStyle(fontSize: 14, color: AppColor.white);

  static TextStyle linkTitle = TextStyle(fontSize: 14, color: AppColor.primary);
  static TextStyle linkTitleWhite =
      TextStyle(fontSize: 14, color: AppColor.white);

  static const TextStyle content =
      TextStyle(fontSize: 16, color: AppColor.black);
  static TextStyle contentWhite =
      TextStyle(fontSize: 16, color: AppColor.white);
  static TextStyle contentPrimary =
      TextStyle(fontSize: 16, color: AppColor.primary);
}
