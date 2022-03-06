import '../constants/appColor.dart';
import '../constants/appStyle.dart';
import 'package:flutter/material.dart';

class AppTab extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final bool selected;
  final bool isMeeting;

  AppTab({
    this.title,
    this.onPressed,
    this.selected = false,
    this.isMeeting = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isMeeting ? AppColor.error : AppColor.primary;
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? color : AppColor.backgroundLight,
          border: Border.all(
            width: 2,
            color: selected ? color : AppColor.primary,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Text(
              title,
              style: selected
                  ? AppStyle.title2White
                  : AppStyle.title2,
            ),
          ),
        ),
      ),
    );
  }
}
