import '../../modules/base/baseView.dart';
import '../../constants/appColor.dart';
import '../../constants/appStyle.dart';
import '../../core/locales/i18nKey.dart';
import '../../core/routes/routeName.dart';
import '../../modules/signIn/signInModel.dart';
import '../../utils/screenUtil.dart';
import '../../widgets/appButton.dart';
import '../../widgets/appInput.dart';
import '../../widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class SignInView extends StatefulWidget {
  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  TextEditingController emailController = TextEditingController();
  // TextEditingController(text: kDebugMode ? 'duongngoanh@gmail.com' : '');
  TextEditingController passwordController = TextEditingController();
  // TextEditingController(text: kDebugMode ? 'fijZif-xeqcab-5cypfa' : '');
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  String _errorMessage = '';
  @override
  Widget build(BuildContext context) {
    emailController.selection =
        TextSelection.collapsed(offset: emailController.text.length);
    passwordController.selection =
        TextSelection.collapsed(offset: passwordController.text.length);
    ScreenUtil.init(context);

    return BaseView<SignInModel>(
        model: SignInModel(context),
        builder: (context, model, _) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: _buildView(context, model),
          );
        });
  }

  Future<void> onSignIn(SignInModel signInModel) async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      await signInModel.signIn(onError: (String error) {
        setState(() {
          _errorMessage = error;
        });
      });
    } else {
      setState(() {
        _autovalidate = AutovalidateMode.onUserInteraction;
      });
    }
  }

  Widget _buildView(
    BuildContext context,
    SignInModel signInModel,
  ) {
    return SafeArea(
      child: LayoutBuilder(builder: (context, size) {
        bool isKeyboardPopUp = size.maxHeight < 560;
        return Column(
          children: [
            Spacer(),
            Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Align(
                    child: Logo(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 24,
                    ),
                    child: Text(
                      '${ScreenUtil.t(I18nKey.signInTitle1).toUpperCase()}',
                      style: AppStyle.h3.copyWith(
                        fontSize: 20,
                        color: AppColor.secondary,
                      ),
                    ),
                  ),
                  LayoutBuilder(
                    builder: (context, size) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        padding: size.maxWidth < 500
                            ? EdgeInsets.zero
                            : const EdgeInsets.all(30),
                        child: Center(
                          child: Container(
                            constraints:
                                BoxConstraints(maxWidth: size.maxWidth - 48),
                            child: Form(
                              key: _key,
                              autovalidateMode: _autovalidate,
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    child: AppInput(
                                      hintText:
                                          '${ScreenUtil.t(I18nKey.email)}',
                                      keyboardType: TextInputType.emailAddress,
                                      controller: emailController,
                                      onSaved: (String value) {
                                        signInModel.email = value.trim();
                                        emailController.text = value.trim();
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          if (_errorMessage.isNotEmpty) {
                                            _errorMessage = '';
                                          }
                                        });
                                      },
                                      validator: (value) {
                                        if (value.isEmpty ||
                                            value.trim().isEmpty) {
                                          return 'Email không được để trống';
                                        }
                                        if (!isEmail(value.trim())) {
                                          return 'Email không hợp lệ';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    child: AppInput(
                                      obscureText: true,
                                      hintText:
                                          '${ScreenUtil.t(I18nKey.password)}',
                                      controller: passwordController,
                                      onSaved: (String value) {
                                        signInModel.password = value.trim();
                                        passwordController.text = value.trim();
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          if (_errorMessage.isNotEmpty) {
                                            _errorMessage = '';
                                          }
                                        });
                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Mật khẩu không được để trống';
                                        }
                                        if (value.length < 6) {
                                          return 'Mật khẩu phải chứa ít nhất 6 kí tự';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  _buildErrorMessage(),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: AppButton(
                                      loading: signInModel.loading,
                                      contained: true,
                                      primary: true,
                                      title:
                                          '${ScreenUtil.t(I18nKey.signIn).toUpperCase()}',
                                      onPressed: () => onSignIn(signInModel),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            !isKeyboardPopUp ? SizedBox(height: 64) : Spacer(),
            AppButton(
              title: '${ScreenUtil.t(I18nKey.forgotPassword).toUpperCase()}',
              onPressed: () =>
                  Navigator.of(context).pushNamed(RouteName.forgotPassword),
            ),
            Spacer(),
          ],
        );
      }),
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
