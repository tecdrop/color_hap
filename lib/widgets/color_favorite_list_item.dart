// Copyright 2020-2024 Tecdrop (https://www.tecdrop.com/)
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.tecdrop.com/colorhap/license/.

import 'dart:math';
import 'package:flutter/material.dart';

import '../common/ui_strings.dart' as strings;
import '../models/random_color.dart';
import '../utils/color_utils.dart' as color_utils;

/// A widget that displays a favorite color list item.
class ColorFavoriteListItem extends StatelessWidget {
  const ColorFavoriteListItem({
    super.key,
    required this.randomColor,
    this.onTap,
    this.onDeletePressed,
  });

  /// The random color to display.
  final RandomColor randomColor;

  /// The function to call when the tile is tapped.
  final void Function()? onTap;

  /// The function to call when the Delete button is pressed.
  final void Function()? onDeletePressed;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return ListTile(
      // Use padding to constrain the width of the list items so they look ok on large screens
      contentPadding: EdgeInsets.symmetric(
        horizontal: max(16.0, (width - 1024) / 2),
        vertical: 32.0,
      ),

      // Fill the tile with the random color, and use the contrast color for the text
      tileColor: randomColor.color,
      textColor: color_utils.contrastColor(randomColor.color),

      // Random color title and type
      title: Text(randomColor.title, style: const TextStyle(fontSize: 20.0)),
      subtitle: Text(strings.colorType[randomColor.type]!),

      // The trailing widget is used to display the Delete button
      trailing: IconButton(
        icon: Icon(Icons.delete_outline, color: color_utils.contrastIconColor(randomColor.color)),
        tooltip: strings.removeFavTooltip,
        onPressed: onDeletePressed,
      ),
      onTap: onTap,
    );
  }
}
