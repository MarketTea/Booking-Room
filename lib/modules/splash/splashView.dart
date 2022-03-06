import '../../constants/appColor.dart';
import '../base/baseView.dart';
import 'splashModel.dart';
import '../../utils/screenUtil.dart';
import '../../widgets/appSpinner.dart';
import '../../widgets/logo.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return BaseView<SplashModel>(
      model: SplashModel(context),
      onModelReady: (model) async {
        await model.init();
      },
      builder: (context, model, _) {
        return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Scaffold(
              body: _buildView(context, model),
            ),
            model.loading ? AppSpinner() : Container()
          ],
        );
      },
    );
  }

  Widget _buildView(BuildContext context, SplashModel model) {
    return Container(
        color: AppColor.white,
        child: Center(
          child: Logo(),
        ));
  }
}
