// Copyright 2020-2024 Tecdrop (https://www.tecdrop.com/)
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.tecdrop.com/colorhap/license/.

import 'dart:math';

import 'package:flutter/material.dart';

import '../common/app_const.dart' as consts;
import '../utils/color_utils.dart' as color_utils;

typedef ColorListItemData = ({
  Color color,
  String title,
  String? subtitle,
});

typedef ItemButtonData = ({
  IconData icon,
  String tooltip,
});

/// A list view that displays a list of available colors.
class ColorListView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: scrollController,
      thumbVisibility: true,
      child: ListView.builder(
        controller: scrollController,
        itemCount: itemCount(),
        itemExtent: consts.colorListItemExtent,
        itemBuilder: (BuildContext context, int index) {
          final ColorListItemData item = itemData(index);
          return _ColorListItem(
            color: item.color,
            title: item.title,
            subtitle: item.subtitle,
            itemButton: itemButton?.call(index),
            onTap: () => onItemTap?.call(index),
            onButtonPressed: () => onItemButtonPressed?.call(index),
          );
        },
      ),
    );
  }
}

class _ColorListItem extends StatelessWidget {
  const _ColorListItem({
    super.key, // ignore: unused_element
    required this.color,
    required this.title,
    this.subtitle,
    this.itemButton,
    this.onTap,
    this.onButtonPressed,
  });

  final Color color;

  final String title;

  final String? subtitle;

  final ItemButtonData? itemButton;

  /// The function to call when the list item is tapped.
  final void Function()? onTap;

  /// A callback function that is called when the button of this list item is pressed.
  final void Function()? onButtonPressed;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    final Color contrastColor = color_utils.contrastColor(color);

    return InkWell(
      onTap: onTap,
      child: Ink(
        color: color,
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
              )
          ],
        ),
      ),
    );
  }
}
