import 'package:demo_b/configs/svg_constants.dart';

import '../../core/locales/i18nKey.dart';
import '../../constants/appColor.dart';
import '../../constants/appImage.dart';
import '../../constants/appStyle.dart';
import '../../core/routes/routeName.dart';
import '../../modules/base/baseView.dart';
import '../../modules/setting/settingModel.dart';
import '../../utils/screenUtil.dart';
import '../../widgets/appSpinner.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';

class SettingView extends StatefulWidget {
  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  final settinglistItemScroll = ScrollController();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return BaseView<SettingModel>(
      model: SettingModel(context),
      onModelReady: (model) async {
        await model.init();
      },
      builder: (context, model, _) {
        return Scaffold(
          body: model.loading ? AppSpinner() : _buildView(context, model),
        );
      },
    );
  }

  Widget _buildView(BuildContext context, SettingModel model) {
    // ThemeModel themeModel = Provider.of<ThemeModel>(context);
    // LocaleModel localeModel = Provider.of<LocaleModel>(context);
    return Material(
      color: AppColor.backgroundLight,
      child: Column(
        children: <Widget>[
          Container(
            width: ScreenUtil.width,
            height: 128,
            color: AppColor.primary,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
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
                    padding: const EdgeInsets.all(1.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${model.currentUser?.fullname ?? ''}',
                          style: AppStyle.h4White,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            '${model.currentUser?.email ?? ''}',
                            style: AppStyle.subtitle1White,
                          ),
                        ),
                        SizedBox(
                          height: 34,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: AppColor.backgroundLight,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              backgroundColor: AppColor.primary,
                            ),
                            child: Row(
                              children: [
                                SvgIcon(
                                  SvgIcons.edit,
                                  color: AppColor.backgroundLight,
                                  size: 16,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text(
                                    '${ScreenUtil.t(I18nKey.userProfile)}',
                                    style: AppStyle.subtitle3,
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(RouteName.userInfo);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: ListView(
                shrinkWrap: true,
                controller: settinglistItemScroll,
                children: [
                  _buildSettingItem(
                    svgIcon: SvgIcons.rateApp,
                    title: '${ScreenUtil.t(I18nKey.rate)}',
                    subTitle: '${ScreenUtil.t(I18nKey.rateAppOnAppStore)}',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    svgIcon: SvgIcons.feedback,
                    title: '${ScreenUtil.t(I18nKey.feedback)}',
                    subTitle: '${ScreenUtil.t(I18nKey.feedbackExperience)}',
                    onTap: () {
                      Navigator.of(context).pushNamed(RouteName.feedback);
                    },
                  ),
                  _buildSettingItem(
                    svgIcon: SvgIcons.support,
                    title: '${ScreenUtil.t(I18nKey.support)}',
                    subTitle: 'Hotline: 084 - 901 234 567',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    svgIcon: SvgIcons.logout,
                    title: '${ScreenUtil.t(I18nKey.signOut)}',
                    svgIconSize: 24,
                    onTap: () async {
                      await model.signOut();
                    },
                  ),
                  InkWell(
                    child: ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgIcon(
                          SvgIcons.codeVersion,
                          color: AppColor.primary,
                          size: 28,
                        ),
                      ),
                      title: FutureBuilder<PackageInfo>(
                        future: PackageInfo.fromPlatform(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              'App Version: ' + snapshot?.data?.version ?? '',
                              style: AppStyle.h3,
                            );
                          }
                          return SizedBox();
                        },
                      ),
                      subtitle: FutureBuilder(
                          future: model.getCodeVersion,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                'Code Version: ' + snapshot.data,
                                style: AppStyle.subtitle1,
                              );
                            }
                            return SizedBox();
                          }),
                    ),
                    onTap: () async {
                      final fcmToken =
                          await FirebaseMessaging.instance.getToken();
                      await Clipboard.setData(ClipboardData(text: fcmToken));
                      // Toast.success(message: 'Done');
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildSettingItem({
    IconData icon,
    String title,
    String subTitle,
    Function() onTap,
    SvgIconData svgIcon,
    double svgIconSize = 28,
  }) {
    return Column(
      children: [
        InkWell(
          child: ListTile(
            leading: svgIcon != null
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
                    size: 34,
                  ),
            title: Text(title, style: AppStyle.h3),
            subtitle: subTitle != null
                ? Text(
                    subTitle,
                    style: AppStyle.subtitle1,
                  )
                : null,
          ),
          onTap: onTap,
        ),
        Divider(),
      ],
    );
  }
}
