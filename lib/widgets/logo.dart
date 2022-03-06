import '../../constants/appColor.dart';
import '../../constants/appImage.dart';
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      height: 104,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(52),
        color: AppColor.primary,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16,16,16,16.75),
        child: SizedBox(
          width: 72,
          height: 71.25,
          child: Image(
            image: AssetImage(AppImage.logo),
          ),
        ),
      ),
    );
  }
}
