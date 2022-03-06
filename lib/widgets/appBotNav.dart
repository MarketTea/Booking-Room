import 'package:demo_b/configs/svg_constants.dart';
import 'package:flutter/material.dart';

class AppBotNavItem {
  IconData iconData;
  String title;
  SvgIconData svgIcon;
  AppBotNavItem({
    this.iconData,
    this.title,
    this.svgIcon,
  });
}

class AppBotNav extends StatefulWidget {
  AppBotNav({
    this.items,
    this.centerButton: false,
    this.width: 72.0,
    this.height: 63.0,
    this.iconSize: 24.0,
    this.backgroundColor,
    this.color,
    this.selectedColor,
    this.notchedShape,
    this.onTabSelected,
    this.modelIndex,
  });

  final List<AppBotNavItem> items;
  final bool centerButton;
  final double width;
  final double height;
  final double iconSize;
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;
  final NotchedShape notchedShape;
  final ValueChanged<int> onTabSelected;
  final int modelIndex;
  @override
  State<StatefulWidget> createState() => AppBotNavState();
}

class AppBotNavState extends State<AppBotNav> {
  int _selectedIndex = 0;

  void _updateIndex(int index) {
    widget.onTabSelected(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: _updateIndex,
      );
    });
    if (widget.centerButton) {
      items.insert(items.length >> 1, SizedBox());
    }

    return BottomAppBar(
      shape: widget.notchedShape,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
      color: widget.backgroundColor,
    );
  }

  Widget _buildTabItem({
    AppBotNavItem item,
    int index,
    ValueChanged<int> onPressed,
  }) {
    if (widget.modelIndex != _selectedIndex) {
      _selectedIndex = widget.modelIndex;
    }
    Color contentColor =
        _selectedIndex == index ? widget.selectedColor : widget.color;
    Color backgroundColor =
        _selectedIndex == index ? widget.color : widget.selectedColor;
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11.5),
        child: TextButton(
          style: TextButton.styleFrom(backgroundColor: backgroundColor),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              item.svgIcon != null
                  ? SvgIcon(
                      item.svgIcon,
                      size: widget.iconSize,
                      color: contentColor,
                    )
                  : Icon(
                      item.iconData,
                      color: contentColor,
                      size: widget.iconSize,
                    ),
            ],
          ),
          onPressed: () => onPressed(index),
        ),
      ),
    );
  }
}
