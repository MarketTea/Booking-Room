import 'package:demo_b/configs/svg_constants.dart';

import '../../constants/appColor.dart';
import '../../constants/appStyle.dart';
import 'package:flutter/material.dart';

class MasterAppScreen extends StatelessWidget {
  final List<ModuleModel> modules;

  MasterAppScreen({this.modules});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: modules.length,
        itemBuilder: (context, index) {
          final module = modules[index];
          return Column(
            children: [
              InkWell(
                child: ListTile(
                  leading: module.svgIcon != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgIcon(
                            module.svgIcon,
                            size: 30,
                            color: AppColor.primary,
                          ),
                        )
                      : Icon(
                          module.icon,
                          color: AppColor.primary,
                          size: 50,
                        ),
                  title: Text(module.title, style: AppStyle.h3),
                  subtitle: Text(module.subTitle),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(module.route);
                },
              ),
              Divider(),
            ],
          );
        },
      ),
    );
  }
}

class ModuleModel {
  final String title;
  final String subTitle;
  final String route;
  final IconData icon;
  final SvgIconData svgIcon;
  ModuleModel({
    @required this.title,
    @required this.subTitle,
    @required this.route,
    this.icon,
    this.svgIcon,
  });
}
