import '../../widgets/appDropdown.dart';

import '../../constants/appImage.dart';
import '../../constants/appStyle.dart';

import '../../widgets/appInput.dart';

import '../../widgets/appButton.dart';

import '../../widgets/appAppBar.dart';
import '../../constants/appColor.dart';
import '../base/baseView.dart';
import '../../utils/screenUtil.dart';
import '../../widgets/appSpinner.dart';

import 'package:flutter/material.dart';

import '../userInfo/userInfoModel.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController dropdownController = TextEditingController();
  TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    dropdownController.selection =
        TextSelection.collapsed(offset: dropdownController.text.length);
    feedbackController.selection =
        TextSelection.collapsed(offset: feedbackController.text.length);
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
            title: 'Phản hồi',
          ),
          body: model.loading ? AppSpinner() : _buildView(context, model),
        );
      },
    );
  }

  Widget _buildView(BuildContext context, UserInfoModel model) {
    final userInfo = model.currentUser;
    final List<Map<String, dynamic>> dropdownData = [
      {'name': 'Chọn', 'value': '', 'isDefault': true},
      {'name': 'Smart Meeting', 'value': 'smart_meeting'},
      {'name': 'Smart Parking', 'value': 'smart_parking'},
      {'name': 'Face Recognization', 'value': 'face_recognization'},
      {'name': 'Healthy Check', 'value': 'healthy_check'},
      {'name': 'Occupancy Monitor', 'value': 'occupancy_monitor'},
      {'name': 'Risk Management', 'value': 'risk_management'},
      {'name': 'Building Management System', 'value': 'building_management'},
      {'name': 'User Management', 'value': 'user_management'},
    ];
    return ListView(
      children: [
        SizedBox(
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
                    mainAxisAlignment: MainAxisAlignment.center,
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _key,
                autovalidateMode: _autovalidate,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: AppDropdown(
                        isExpanded: true,
                        headerTitle: 'Danh mục phản hồi',
                        value: dropdownController.text,
                        dropdownData: dropdownData,
                        onChanged: (value) {
                          setState(() {
                            dropdownController.text = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: AppInput(
                        headerTitle: 'Nội dung phản hồi',
                        controller: feedbackController,
                        keyboardType: TextInputType.multiline,
                        multiline: 8,
                        outlined: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Nội dung phản hồi không được để trống';
                          }
                          if (value.trim().length > 1000) {
                            return 'Nội dung phản hồi không quá 1000 ký tự';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          feedbackController.text = value.trim();
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: AppButton(
                        height: 42,
                        full: true,
                        contained: true,
                        rectangle: true,
                        primary: true,
                        title: 'Gửi phản hồi',
                        onPressed: () {
                          if (_key.currentState.validate()) {
                            _key.currentState.save();
                            Navigator.of(context).pop();
                          } else {
                            setState(() {
                              _autovalidate =
                                  AutovalidateMode.onUserInteraction;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
