// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'dart:math';
import 'package:flutter/material.dart';

import '../common/consts.dart' as consts;
import '../models/color_item.dart';
import '../utils/color_utils.dart' as color_utils;
import 'color_info_display.dart';

/// Data for an optional button that can be displayed for each item in the list.
typedef ItemButtonData = ({IconData icon, String tooltip});

/// A list view that displays a list of available colors.
class ColorListView extends StatefulWidget {
  const ColorListView({
    super.key, // ignore: unused_element
    this.scrollController,
    required this.itemCount,
    required this.itemData,
    this.showColorType,
    this.itemButton,
    this.onItemTap,
    this.onItemButtonPressed,
  });

  /// An optional scroll controller for the list view.
  final ScrollController? scrollController;

  /// A callback function that returns the number of items to display in the list.
  final int itemCount;

  /// A callback function that returns the title, subtitle, and color for each item in the list.
  final ColorItem Function(int index) itemData;

  /// A function that determines whether to show the color type for each item.
  ///
  /// The function is called with the [ColorItem] and should return true to show the color type
  /// or false to hide it. If null, color types will be shown for all items by default.
  final bool Function(ColorItem)? showColorType;

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
        itemCount: widget.itemCount,
        itemExtent: consts.colorListItemExtent,
        itemBuilder: (BuildContext context, int index) {
          final colorItem = widget.itemData(index);
          return _ColorListItem(
            colorItem: colorItem,
            showColorType: widget.showColorType?.call(colorItem) ?? true,
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
    super.key, // ignore: unused_element_parameter
    required this.colorItem,
    this.showColorType = true,
    this.itemButton,
    this.focused = false,
    this.onTap,
    this.onButtonPressed,
    this.onFocusChange,
  });

  /// The color item to display.
  final ColorItem colorItem;

  /// Whether to show the color type as a subtitle.
  final bool showColorType;

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
    final width = MediaQuery.sizeOf(context).width;
    final color = colorItem.color;
    final contrastColor = color_utils.contrastColor(color);

    return InkWell(
      onFocusChange: onFocusChange,
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: color,
          border: .all(color: focused ? Colors.grey[700]! : color, width: 6.0),
        ),

        // Use padding to constrain the width of the list items so they look ok on large screens
        padding: .symmetric(horizontal: max(16.0, (width - 1024) / 2)),

        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: <Widget>[
            ColorInfoDisplay(
              colorItem: colorItem,
              contrastColor: contrastColor,
              showType: showColorType,
              size: .small,
              centered: false,
            ),
            if (itemButton != null)
              IconButton(
                icon: Icon(itemButton!.icon, color: color_utils.contrastIconColor(color)),
                tooltip: itemButton!.tooltip,
                onPressed: onButtonPressed,
                focusColor: contrastColor.withValues(alpha: 0.25),
              ),
          ],
        ),
      ),
    );
  }
}
