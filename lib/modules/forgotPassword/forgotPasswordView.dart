import '../../widgets/appAppBar.dart';

import '../../constants/appColor.dart';
import '../../constants/appStyle.dart';
import 'package:validators/validators.dart';

import '../../modules/base/baseView.dart';
import '../../core/locales/i18nKey.dart';
import 'forgotPasswordModel.dart';
import '../../utils/screenUtil.dart';
import '../../widgets/appButton.dart';
import '../../widgets/appInput.dart';
import '../../widgets/appSpinner.dart';
import 'package:flutter/material.dart';

class ForgotPasswordView extends StatefulWidget {
  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return BaseView<ForgotPasswordModel>(
        model: ForgotPasswordModel(context),
        builder: (context, model, _) {
          return Scaffold(
            backgroundColor: AppColor.backgroundLight,
            appBar: AppAppBar(
              backgroundColor: AppColor.white,
              allowBack: true,
            ),
            body: model.loading
                ? AppSpinner()
                : _buildView(
                    context,
                    model,
                  ),
          );
        });
  }

  Future<void> onForgotPassword(
    ForgotPasswordModel forgotPasswordModel,
  ) async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      await forgotPasswordModel.forgotPassword();
    } else {
      setState(() {
        _autovalidate = AutovalidateMode.onUserInteraction;
      });
    }
  }

  Widget _buildView(
    BuildContext context,
    ForgotPasswordModel forgotPasswordModel,
  ) {
    return SafeArea(
      child: Form(
        key: _key,
        autovalidateMode: _autovalidate,
        child: Column(
          children: [
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  AppInput(
                    headerTitle: '${ScreenUtil.t(I18nKey.forgotPassword)}'.toUpperCase(),
                    hintText: '${ScreenUtil.t(I18nKey.email)}',
                    headerStyle:
                        AppStyle.h3.copyWith(color: AppColor.secondary),
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    onSaved: (String value) {
                      forgotPasswordModel.email = value.trim();
                      emailController.text = value.trim();
                    },
                    validator: (value) {
                      if (value.isEmpty || value.trim().isEmpty) {
                        return 'Email không được để trống';
                      }
                      if (!isEmail(value.trim())) {
                        return 'Email không hợp lệ';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: ScreenUtil.height / 12,
                  ),
                  AppButton(
                    full: true,
                    contained: true,
                    primary: true,
                    title: '${ScreenUtil.t(I18nKey.forgotPassword)}',
                    onPressed: () => onForgotPassword(forgotPasswordModel),
                  ),
                ],
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
