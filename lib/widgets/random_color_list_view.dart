// Copyright 2020-2024 Tecdrop (https://www.tecdrop.com/)
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.tecdrop.com/colorhap/license/.

import 'dart:math';

import 'package:flutter/material.dart';

import '../common/app_const.dart' as consts;
import '../models/random_color.dart';
import '../utils/color_utils.dart' as color_utils;
import '../common/ui_strings.dart' as strings;

/// A list view that displays a list of available colors.
class RandomColorListView extends StatelessWidget {
  const RandomColorListView({
    super.key, // ignore: unused_element
    this.scrollController,
    required this.itemCount,
    required this.itemData,
    this.showColorType = false,
    this.onItemTap,
  });

  /// An optional scroll controller for the list view.
  final ScrollController? scrollController;

  /// A callback function that returns the number of items to display in the list.
  final int Function() itemCount;

  /// A callback function that returns the color code and title for each item in the list.
  final RandomColor Function(int index) itemData;

  /// Whether to show the color type in the list item as the subtitle.
  final bool showColorType;

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
          return _RandomColorListItem(
            item: itemData(index),
            showColorType: showColorType,
            onTap: () => onItemTap?.call(index),
          );
        },
      ),
    );
  }
}

class _RandomColorListItem extends StatelessWidget {
  const _RandomColorListItem({
    super.key, // ignore: unused_element
    required this.item,
    this.showColorType = false,
    this.onTap,
  });

  /// The random color to display in the list item.
  final RandomColor item;

  /// Whether to show the color type in the list item as the subtitle.
  final bool showColorType;

  /// The function to call when the list item is tapped.
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    final String title = showColorType ? item.longTitle : item.title;
    final String? subtitle = showColorType
        ? strings.colorType[item.type]!
        : item.name != null
            ? item.hexString
            : null;

    final Color itemColor = item.color;
    final Color contrastColor = color_utils.contrastColor(itemColor);

    return InkWell(
      onTap: onTap,
      child: Ink(
        color: itemColor,
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
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: contrastColor),
              ),
          ],
        ),
      ),
    );
  }
}
