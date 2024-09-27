// Copyright 2020-2024 Tecdrop (https://www.tecdrop.com/)
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.tecdrop.com/colorhap/license/.

import 'dart:math';

import 'package:flutter/material.dart';

import '../common/app_const.dart' as consts;
import '../models/random_color.dart';
import '../utils/color_utils.dart' as color_utils;

/// A list view that displays a list of available colors.
class AvailableColorsListView extends StatelessWidget {
  const AvailableColorsListView({
    super.key, // ignore: unused_element
    this.scrollController,
    required this.itemCount,
    required this.itemData,
    this.onItemTap,
  });

  /// An optional scroll controller for the list view.
  final ScrollController? scrollController;

  /// A callback function that returns the number of items to display in the list.
  final int Function() itemCount;

  /// A callback function that returns the color code and title for each item in the list.
  final RandomColor Function(int index) itemData;

  /// A callback function that is called when an item in the list is tapped.
  final void Function(int index)? onItemTap;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scrollbar(
      child: ListView.builder(
        controller: scrollController,
        itemCount: itemCount(),
        itemExtent: consts.colorListItemExtent,
        itemBuilder: (BuildContext context, int index) {
          final RandomColor item = itemData(index);
          final Color itemColor = item.color;
          final Color contrastColor = color_utils.contrastColor(itemColor);

          return InkWell(
            onTap: () => onItemTap?.call(index),
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
                    item.title,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(color: contrastColor),
                  ),
                  if (item.name != null)
                    Text(
                      item.hexString,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: contrastColor),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
