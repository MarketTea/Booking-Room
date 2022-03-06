import 'package:demo_b/configs/svg_constants.dart';

import '../../constants/appColor.dart';
import '../../constants/appStyle.dart';
import '../../utils/screenUtil.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  AppButton({
    @required this.title,
    this.onPressed,
    this.contained = false,
    this.full = false,
    this.primary = false,
    this.width: 152,
    this.height: 48,
    this.loading = false,
    this.rectangle = false,
    this.icon,
    this.iconSize: 16,
    this.svgIcon,
    this.svgIconSize: 24,
  });

  final String title;
  final Function() onPressed;
  final bool contained;
  final bool full;
  final bool primary;
  final double width;
  final double height;
  final bool loading;
  final bool rectangle;
  final IconData icon;
  final double iconSize;
  final SvgIconData svgIcon;
  final double svgIconSize;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    if (contained) {
      if (rectangle) {
        return SizedBox(
          width: full ? ScreenUtil.width : width,
          height: height,
          child: TextButton(
            onPressed: onPressed,
            child: loading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: primary ? AppColor.white : AppColor.primary,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (svgIcon != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgIcon(
                            svgIcon,
                            color: AppColor.primary,
                            size: svgIconSize,
                          ),
                        ),
                      if (icon != null)
                        Icon(
                          icon,
                          color: primary ? AppColor.white : AppColor.primary,
                          size: iconSize,
                        ),
                      Padding(
                        padding: EdgeInsets.only(left: icon != null ? 8 : 0),
                        child: Text(
                          '$title',
                          style: primary
                              ? AppStyle.linkTitleWhite
                              : AppStyle.linkTitle,
                        ),
                      ),
                    ],
                  ),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: AppColor.primary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              backgroundColor: primary ? AppColor.primary : AppColor.white,
            ),
          ),
        );
      } else {
        return SizedBox(
          width: full ? ScreenUtil.width : width,
          height: height,
          child: TextButton(
            onPressed: onPressed,
            child: loading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: primary ? AppColor.white : AppColor.primary,
                    ),
                  )
                : Text('$title',
                    style: primary ? AppStyle.title1White : AppStyle.title2),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: AppColor.primary,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              backgroundColor: primary ? AppColor.primary : AppColor.white,
            ),
          ),
        );
      }
    }
    return TextButton(
      child: Text(
        '$title',
        style: primary ? AppStyle.title1White : AppStyle.title2,
      ),
      onPressed: onPressed,
    );
  }
}
