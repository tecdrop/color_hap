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

/// A list view that displays a list of available colors.
class ColorListView extends StatelessWidget {
  const ColorListView({
    super.key, // ignore: unused_element
    this.scrollController,
    required this.itemCount,
    required this.itemData,
    this.actionButton,
    this.onItemTap,
  });

  /// An optional scroll controller for the list view.
  final ScrollController? scrollController;

  /// A callback function that returns the number of items to display in the list.
  final int Function() itemCount;

  /// A callback function that returns the title, subtitle, and color for each item in the list.
  final ColorListItemData Function(int index) itemData;

  /// A callback function that returns an optional action button for each item in the list.
  final Widget Function(int index)? actionButton;

  /// A callback function that is called when an item in the list is tapped.
  final void Function(int index)? onItemTap;

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
            actionButton: actionButton?.call(index),
            onTap: () => onItemTap?.call(index),
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
    this.actionButton,
    this.onTap,
  });

  final Color color;

  final String title;

  final String? subtitle;

  final Widget? actionButton;

  /// The function to call when the list item is tapped.
  final void Function()? onTap;

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

        child: Column(
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
            if (actionButton != null) actionButton!,
          ],
        ),
      ),
    );
  }
}
