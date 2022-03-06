import 'package:demo_b/configs/svg_constants.dart';

import '../../widgets/appAppBar.dart';
import '../../constants/appColor.dart';
import '../../constants/appImage.dart';
import '../../constants/appStyle.dart';
import '../../core/routes/routeName.dart';
import '../../modules/base/baseView.dart';
import '../../utils/screenUtil.dart';
import '../../widgets/appSpinner.dart';

import 'package:flutter/material.dart';

import 'userInfoModel.dart';

class UserInfoScreen extends StatefulWidget {
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return BaseView<UserInfoModel>(
      model: UserInfoModel(context),
      onModelReady: (model) async {
        await model.init();
      },
      builder: (context, model, _) {
        return Scaffold(
          appBar: AppAppBar(
            allowBack: true,
            centerTitle: true,
            title: 'Hồ sơ người dùng',
          ),
          body: model.loading ? AppSpinner() : _buildView(context, model),
        );
      },
    );
  }

  Widget _buildView(BuildContext context, UserInfoModel model) {
    final userInfo = model.currentUser;
    return Material(
      color: AppColor.backgroundLight,
      child: Column(
        children: <Widget>[
          Container(
            width: ScreenUtil.width,
            height: 128,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 16,
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColor.backgroundLight,
                      child: CircleAvatar(
                        radius: 38,
                        backgroundImage: AssetImage(AppImage.logo),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${userInfo?.fullname ?? ''}',
                          style: AppStyle.h4,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            '${userInfo?.email ?? ''}',
                            style: AppStyle.subtitle1,
                          ),
                        ),
                        InkWell(
                          child: Text(
                            'Đổi mật khẩu',
                            style: AppStyle.linkTitle,
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(RouteName.editPassword);
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Align(
              child: Text(
                'Thông tin liên hệ'.toUpperCase(),
                style: AppStyle.h5,
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            child: ListView(
              shrinkWrap: true,
              children: [
                _buildInfoItem(
                  svgIcon: SvgIcons.telephone,
                  title: 'Số điện thoại',
                  subTitle: userInfo?.phoneNumber,
                  onTap: () {},
                ),
                _buildInfoItem(
                  svgIcon: SvgIcons.email,
                  title: 'Email',
                  subTitle: userInfo?.email,
                  onTap: () {},
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Align(
              child: Text(
                'Chức vụ'.toUpperCase(),
                style: AppStyle.h5,
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            child: ListView(
              shrinkWrap: true,
              children: [
                _buildInfoItem(
                  svgIcon: SvgIcons.smartMeeting,
                  title: userInfo?.admin ?? false ? 'Admin' : 'User',
                  onTap: () {},
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: SizedBox(
              height: 42,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: AppColor.primary,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  backgroundColor: AppColor.backgroundLight,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgIcon(
                      SvgIcons.edit,
                      color: AppColor.primary,
                      size: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        'Chỉnh sửa thông tin',
                        style: AppStyle.linkTitle,
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(RouteName.editInfo);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildInfoItem({
    IconData icon,
    String title,
    String subTitle,
    Function() onTap,
    SvgIconData svgIcon,
    double svgIconSize = 28,
  }) {
    return InkWell(
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColor.secondaryLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: svgIcon != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgIcon(
                    svgIcon,
                    color: AppColor.primary,
                    size: svgIconSize,
                  ),
                )
              : Icon(
                  icon,
                  color: AppColor.primary,
                  size: 24,
                ),
        ),
        title: Text(
          title,
          style: subTitle != null ? AppStyle.subtitle1Light : AppStyle.h3,
        ),
        subtitle: subTitle != null
            ? Text(
                subTitle,
                style: AppStyle.h3,
              )
            : null,
      ),
      onTap: onTap,
    );
  }
}
