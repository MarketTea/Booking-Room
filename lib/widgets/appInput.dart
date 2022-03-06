import '../../constants/appColor.dart';

import '../../constants/appStyle.dart';
import 'package:flutter/material.dart';

class AppInput extends StatefulWidget {
  AppInput({
    this.hintText,
    this.labelText,
    this.errorText,
    this.controller,
    this.onChanged,
    this.obscureText = false,
    this.multiline = 1,
    this.search = false,
    this.focusNode,
    this.onSearch,
    this.validator,
    this.headerTitle: '',
    this.headerStyle: AppStyle.h5,
    this.outlined = false,
    this.enable = true,
    this.keyboardType: TextInputType.multiline,
    this.onSaved,
  });

  final String hintText;
  final String labelText;
  final String errorText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final bool obscureText;
  final int multiline;
  final bool search;
  final Function() onSearch;
  final String Function(String) validator;
  final String headerTitle;
  final TextStyle headerStyle;
  final bool outlined;
  final bool enable;
  final TextInputType keyboardType;
  final Function(String) onSaved;

  @override
  _AppInputState createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.headerTitle.isNotEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                widget.headerTitle,
                style: widget.headerStyle,
              ),
            ),
          ),
        TextFormField(
          readOnly: !widget.enable,
          keyboardType: widget.keyboardType,
          minLines: widget.multiline ?? 1,
          focusNode: widget.focusNode,
          maxLines: widget.multiline,
          obscureText: widget.obscureText && !showPassword,
          controller: widget.controller,
          decoration: _inputDecoration(),
          onChanged: widget.onChanged ?? null,
          onSaved: widget.onSaved ?? null,
          validator: widget.validator,
        ),
      ],
    );
  }

  InputDecoration _inputDecoration() {
    return widget.outlined
        ? InputDecoration(
            prefixIcon: widget.search
                ? IconButton(
                    icon: Icon(Icons.search),
                    onPressed: widget.onSearch,
                  )
                : null,
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    })
                : null,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.enable ? AppColor.black : AppColor.grey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.enable ? AppColor.black : AppColor.grey,
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor.error,
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
            hintText: widget.hintText ?? widget.hintText,
            hintStyle: AppStyle.title2Secondary,
            labelText: widget.labelText ?? widget.labelText,
            errorText: widget.errorText,
          )
        : InputDecoration(
            prefixIcon: widget.search
                ? IconButton(
                    icon: Icon(Icons.search),
                    onPressed: widget.onSearch,
                  )
                : null,
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    })
                : null,
            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            hintText: widget.hintText ?? widget.hintText,
            hintStyle: AppStyle.title2Secondary,
            labelText: widget.labelText ?? widget.labelText,
            errorText: widget.errorText,
          );
  }
}
