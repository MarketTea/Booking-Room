import '../../constants/appColor.dart';
import '../../constants/appStyle.dart';
import 'package:flutter/material.dart';

class AppDropdown extends StatelessWidget {
  final String value;
  final Function(String) onChanged;
  final List<Map<String, dynamic>> dropdownData;
  final bool isExpanded;
  final String headerTitle;
  final TextStyle headerStyle;
  AppDropdown({
    this.value,
    this.onChanged,
    this.dropdownData,
    this.isExpanded = false,
    this.headerTitle: '',
    this.headerStyle: AppStyle.h5,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (headerTitle.isNotEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                headerTitle,
                style: headerStyle,
              ),
            ),
          ),
        DropdownButtonFormField<String>(
          isExpanded: isExpanded,
          value: value,
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 16,
            color: onChanged != null ? AppColor.black : AppColor.grey,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 11, horizontal: 10),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor.black,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor.black,
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
          items: dropdownData.map((Map<String, dynamic> value) {
            final isDefault = value['isDefault'] ?? false;
            return DropdownMenuItem<String>(
              value: value['value'] as String,
              child: Text(
                value['name'],
                style: isDefault || onChanged == null
                    ? AppStyle.title2Secondary
                    : AppStyle.h4,
              ),
            );
          }).toList(),
          onChanged: onChanged ?? null,
        ),
      ],
    );
  }
}
