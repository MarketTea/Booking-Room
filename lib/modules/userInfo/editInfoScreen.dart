import '../../widgets/appInput.dart';

import '../../widgets/appButton.dart';

import '../../widgets/appAppBar.dart';
import '../../constants/appColor.dart';
import '../../constants/appImage.dart';
import '../../constants/appStyle.dart';
import '../../modules/base/baseView.dart';
import '../../utils/screenUtil.dart';
import '../../widgets/appSpinner.dart';

import 'package:flutter/material.dart';

import 'userInfoModel.dart';

class EditInfoScreen extends StatefulWidget {
  @override
  _EditInfoScreenState createState() => _EditInfoScreenState();
}

class _EditInfoScreenState extends State<EditInfoScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
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
          backgroundColor: AppColor.backgroundLight,
          appBar: AppAppBar(
            allowBack: true,
            centerTitle: true,
            title: 'Chỉnh sửa thông tin cá nhân',
          ),
          body: model.loading ? AppSpinner() : _buildView(context, model),
        );
      },
    );
  }

  Widget _buildView(BuildContext context, UserInfoModel model) {
    final userInfo = model.currentUser;

    return Form(
      key: _key,
      autovalidateMode: _autovalidate,
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(AppImage.logo),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: AppButton(
                    contained: true,
                    height: 34,
                    width: 115,
                    title: 'Tải ảnh lên',
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              children: [
                _buildEditItem(
                  controller: nameController,
                  title: 'Họ và Tên',
                  hintText: userInfo?.fullname,
                  onSaved: (value) {
                    nameController.text = value.trim();
                  },
                ),
                _buildEditItem(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  title: 'Số điện thoại',
                  hintText: userInfo?.phoneNumber,
                  onSaved: (value) {
                    phoneController.text = value.trim();
                  },
                  validator: (value) {
                    if (value.isEmpty || value.trim().isEmpty) {
                      return 'Số điện thoại không được để trống';
                    }
                    String pattern =
                        r'^(\+843|\+845|\+847|\+848|\+849|\+841|03|05|07|08|09|01[2|6|8|9])+([0-9]{8})$';
                    RegExp regExp = new RegExp(pattern);
                    if (!regExp.hasMatch(value)) {
                      return 'Số điện thoại không hợp lệ';
                    }
                    return null;
                  },
                ),
                _buildEditItem(
                  controller: emailController,
                  enable: false,
                  style: AppStyle.subtitle1Light
                      .copyWith(fontWeight: FontWeight.bold),
                  title: 'Email',
                  hintText: userInfo?.email,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: AppButton(
              height: 42,
              full: true,
              contained: true,
              rectangle: true,
              primary: true,
              icon: Icons.check_circle_outline,
              iconSize: 20,
              title: 'Lưu thay đổi',
              onPressed: () {
                if (_key.currentState.validate()) {
                  _key.currentState.save();
                  Navigator.of(context).pop();
                } else {
                  setState(() {
                    _autovalidate = AutovalidateMode.onUserInteraction;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildEditItem({
    TextEditingController controller,
    String title,
    Function(String) onSaved,
    String hintText,
    bool enable,
    TextStyle style,
    TextInputType keyboardType,
    Function(String) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: AppInput(
        controller: controller,
        outlined: true,
        headerStyle: style ?? AppStyle.h5,
        enable: enable ?? true,
        keyboardType: keyboardType ?? TextInputType.multiline,
        headerTitle: title,
        onSaved: onSaved,
        hintText: hintText,
        validator: enable ?? true
            ? validator ??
                (value) {
                  if (value.isEmpty || value.trim().isEmpty) {
                    return 'Thông tin không được để trống';
                  }
                  return null;
                }
            : null,
      ),
    );
  }
}
