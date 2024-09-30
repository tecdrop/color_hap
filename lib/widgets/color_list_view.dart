// Copyright 2020-2024 Tecdrop (https://www.tecdrop.com/)
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.tecdrop.com/colorhap/license/.

import 'dart:math';
import 'package:flutter/material.dart';

import '../common/consts.dart' as consts;
import '../utils/color_utils.dart' as color_utils;

/// Data for an item in the color list view.
typedef ColorListItemData = ({
  Color color,
  String title,
  String? subtitle,
});

/// Data for an optional button that can be displayed for each item in the list.
typedef ItemButtonData = ({
  IconData icon,
  String tooltip,
});

/// A list view that displays a list of available colors.
class ColorListView extends StatefulWidget {
  const ColorListView({
    super.key, // ignore: unused_element
    this.scrollController,
    required this.itemCount,
    required this.itemData,
    this.itemButton,
    this.onItemTap,
    this.onItemButtonPressed,
  });

  /// An optional scroll controller for the list view.
  final ScrollController? scrollController;

  /// A callback function that returns the number of items to display in the list.
  final int Function() itemCount;

  /// A callback function that returns the title, subtitle, and color for each item in the list.
  final ColorListItemData Function(int index) itemData;

  /// A callback function that returns an optional button for each item in the list.
  final ItemButtonData Function(int index)? itemButton;

  /// A callback function that is called when an item in the list is tapped.
  final void Function(int index)? onItemTap;

  /// A callback function that is called when the button of a list item is pressed.
  final void Function(int index)? onItemButtonPressed;

  @override
  State<ColorListView> createState() => _ColorListViewState();
}

class _ColorListViewState extends State<ColorListView> {
  /// The index of the currently focused item in the list.
  ///
  /// We keep track of this to highlight the focused item using a border.
  int focusedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: widget.scrollController,
      thumbVisibility: true,
      child: ListView.builder(
        primary: widget.scrollController == null,
        controller: widget.scrollController,
        itemCount: widget.itemCount(),
        itemExtent: consts.colorListItemExtent,
        itemBuilder: (BuildContext context, int index) {
          final ColorListItemData item = widget.itemData(index);
          return _ColorListItem(
            color: item.color,
            title: item.title,
            subtitle: item.subtitle,
            itemButton: widget.itemButton?.call(index),
            focused: index == focusedIndex,
            onTap: () => widget.onItemTap?.call(index),
            onButtonPressed: () => widget.onItemButtonPressed?.call(index),
            onFocusChange: (bool hasFocus) => setState(() {
              focusedIndex = hasFocus ? index : -1;
            }),
          );
        },
      ),
    );
  }
}

/// A list item that displays a color with a title and an optional subtitle and button.
class _ColorListItem extends StatelessWidget {
  const _ColorListItem({
    super.key, // ignore: unused_element
    required this.color,
    required this.title,
    this.subtitle,
    this.itemButton,
    this.focused = false,
    this.onTap,
    this.onButtonPressed,
    this.onFocusChange,
  });

  /// The color of the list item.
  final Color color;

  /// The title of the list item.
  final String title;

  /// The optional subtitle of the list item.
  final String? subtitle;

  /// Data for the optional button of the list item.
  final ItemButtonData? itemButton;

  /// Whether the list item is currently focused.
  final bool focused;

  /// The function to call when the list item is tapped.
  final void Function()? onTap;

  /// A callback function that is called when the button of this list item is pressed.
  final void Function()? onButtonPressed;

  /// A callback function that is called when the focus state of this list item changes.
  final void Function(bool)? onFocusChange;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    final Color contrastColor = color_utils.contrastColor(color);

    return InkWell(
      onFocusChange: onFocusChange,
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: focused ? Colors.grey[700]! : color,
            width: 6.0,
          ),
        ),

        // Use padding to constrain the width of the list items so they look ok on large screens
        padding: EdgeInsets.symmetric(
          horizontal: max(16.0, (width - 1024) / 2),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(color: contrastColor),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: contrastColor),
                  ),
              ],
            ),
            if (itemButton != null)
              IconButton(
                icon: Icon(itemButton!.icon, color: color_utils.contrastIconColor(color)),
                tooltip: itemButton!.tooltip,
                onPressed: onButtonPressed,
                focusColor: contrastColor.withOpacity(0.25),
              )
          ],
        ),
      ),
    );
  }
}
