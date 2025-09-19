// Copyright 2020-2025 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'dart:math';
import 'package:flutter/material.dart';

import '../common/strings.dart' as strings;
import '../utils/color_utils.dart' as color_utils;

/// A list view of color information items.
class ColorInfoList extends StatelessWidget {
  /// Creates a new [ColorInfoList] instance.
  const ColorInfoList({
    super.key,
    required this.color,
    required this.infos,
    this.onCopyPressed,
    this.onSharePressed,
  });

  /// The random color whose information is displayed in the list.
  final Color color;

  /// The list of color information items to display.
  final List<({String key, String value})> infos;

  /// A callback function that is called when the copy button of an info item is pressed.
  final void Function(String key, String value)? onCopyPressed;

  /// A callback function that is called when the share button of an info item is pressed.
  final void Function(String key, String value)? onSharePressed;

  @override
  Widget build(BuildContext context) {
    final Color contrastColor = color_utils.contrastColor(color);
    final double width = MediaQuery.of(context).size.width;

    return DividerTheme(
      // Use a hairline divider between the list items
      data: DividerThemeData(color: contrastColor, thickness: 0.0, space: 0.0),
      child: ListView.separated(
        // Use padding to constrain the width of the list items so they look ok on large screens
        // Also add some bottom padding to the list to make space for the floating action button
        padding: EdgeInsets.symmetric(horizontal: max(0, (width - 800) / 2)).copyWith(bottom: 64.0),

        itemCount: infos.length,
        itemBuilder: (BuildContext context, int index) {
          final info = infos[index];

          // Build a ColorInfoItem for each info item
          return _ColorInfoItem(
            textColor: contrastColor,
            infoKey: info.key,
            infoValue: info.value,
            onCopyPressed: () => onCopyPressed?.call(info.key, info.value),
            onSharePressed: () => onSharePressed?.call(info.key, info.value),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}

/// A list item widget that displays color information.
class _ColorInfoItem extends StatelessWidget {
  const _ColorInfoItem({
    super.key, // ignore: unused_element_parameter
    required this.textColor,
    required this.infoKey,
    required this.infoValue,
    this.onCopyPressed,
    this.onSharePressed,
  });

  /// The text color to use for the list item.
  final Color textColor;

  /// The key of the color information to display.
  final String infoKey;

  /// The value of the color information to display.
  final String infoValue;

  /// A callback function that is called when the copy button of the list item is pressed.
  final void Function()? onCopyPressed;

  /// A callback function that is called when the share button of the list item is pressed.
  final void Function()? onSharePressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Style the list item
      // contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      textColor: textColor,
      iconColor: textColor.withValues(alpha: 0.7),

      // Display the color information key and value
      title: Text(infoValue, style: const TextStyle(fontSize: 20.0)),
      subtitle: Text(infoKey),

      // Add the Copy and Share buttons to the trailing widget
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.content_copy_outlined),
            tooltip: strings.itemCopyTooltip,
            onPressed: onCopyPressed,
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: strings.itemShareTooltip,
            onPressed: onSharePressed,
          ),
        ],
      ),
    );
  }
}
