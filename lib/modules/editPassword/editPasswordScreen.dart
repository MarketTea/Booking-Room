import '../../modules/editPassword/editPasswordModel.dart';
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

class EditPasswordScreen extends StatefulWidget {
  @override
  _EditPasswordScreenState createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController checkController = TextEditingController();
  String _errorMessage = '';
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    oldPasswordController.selection =
        TextSelection.collapsed(offset: oldPasswordController.text.length);
    newPasswordController.selection =
        TextSelection.collapsed(offset: newPasswordController.text.length);
    checkController.selection =
        TextSelection.collapsed(offset: checkController.text.length);

    return BaseView<EditPasswordModel>(
      model: EditPasswordModel(context),
      onModelReady: (model) async {
        await model.init();
      },
      builder: (context, model, _) {
        return Scaffold(
          backgroundColor: AppColor.backgroundLight,
          appBar: AppAppBar(
            allowBack: true,
            centerTitle: true,
            title: 'Đổi mật khẩu',
          ),
          body: model.loading ? AppSpinner() : _buildView(context, model),
        );
      },
    );
  }

  editPassword(EditPasswordModel model) async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      await model.editPassword(
          params: {
            'password': oldPasswordController.text,
            'newPassword': newPasswordController.text,
          },
          onError: (e) {
            setState(() {
              _errorMessage = e;
            });
          });
      if (_errorMessage.isEmpty) {
        Navigator.of(context).pop();
      }
    } else {
      setState(() {
        _autovalidate = AutovalidateMode.onUserInteraction;
      });
    }
  }

  Widget _buildView(BuildContext context, EditPasswordModel model) {
    final userInfo = model.currentUser;

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
                    _buildEditItem(
                      controller: oldPasswordController,
                      hintText: 'Mật khẩu cũ',
                      onSaved: (value) {
                        oldPasswordController.text = value.trim();
                      },
                      onChanged: (value) {
                        setState(() {
                          if (_errorMessage.isNotEmpty) {
                            _errorMessage = '';
                          }
                        });
                      },
                      validator: (value) {
                        if (value.isEmpty || value.trim().isEmpty) {
                          return 'Thông tin không được để trống';
                        }
                        if (value.length < 6) {
                          return 'Mật khẩu phải chứa ít nhất 6 kí tự';
                        }
                        return null;
                      },
                    ),
                    _buildEditItem(
                      controller: newPasswordController,
                      hintText: 'Mật khẩu mới',
                      onSaved: (value) {
                        newPasswordController.text = value.trim();
                      },
                      onChanged: (value) {
                        setState(() {
                          if (_errorMessage.isNotEmpty) {
                            _errorMessage = '';
                          }
                        });
                      },
                      validator: (value) {
                        if (value.isEmpty || value.trim().isEmpty) {
                          return 'Thông tin không được để trống';
                        }
                        if (value.length < 6) {
                          return 'Mật khẩu phải chứa ít nhất 6 kí tự';
                        }
                        if (value.trim() == oldPasswordController.text) {
                          return 'Mật khẩu mới trùng với mật khẩu cũ';
                        }
                        return null;
                      },
                    ),
                    _buildEditItem(
                      controller: checkController,
                      hintText: 'Nhập lại mật khẩu mới',
                      onSaved: (value) {
                        checkController.text = value.trim();
                      },
                      onChanged: (value) {
                        setState(() {
                          if (_errorMessage.isNotEmpty) {
                            _errorMessage = '';
                          }
                        });
                      },
                      validator: (value) {
                        if (value.isEmpty || value.trim().isEmpty) {
                          return 'Thông tin không được để trống';
                        }
                        if (value.trim() != newPasswordController.text) {
                          return 'Nhập sai mật khẩu mới';
                        }
                        return null;
                      },
                    ),
                    _buildErrorMessage(),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
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
                          editPassword(model);
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

  _buildEditItem({
    TextEditingController controller,
    Function(String) onSaved,
    String hintText,
    Function(String) validator,
    Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: AppInput(
        outlined: true,
        obscureText: true,
        controller: controller,
        onSaved: onSaved,
        hintText: hintText,
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }

  _buildErrorMessage() {
    return _errorMessage != null && _errorMessage.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: double.infinity,
                minHeight: 24,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(
                    color: Theme.of(context).errorColor,
                    width: 1,
                  ),
                ),
                child: Padding(
                  child: Text(
                    _errorMessage,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).errorColor,
                        ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
