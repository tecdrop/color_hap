// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../common/ui_strings.dart' as strings;
import '../models/random_color.dart';
import '../utils/color_utils.dart' as color_utils;

/// A list view of color information items.
class ColorInfoList extends StatelessWidget {
  /// Creates a new [ColorInfoList] instance.
  const ColorInfoList({
    super.key,
    required this.randomColor,
    this.onCopyPressed,
  });

  /// The random color whose information is displayed in the list.
  final RandomColor randomColor;

  /// A callback function that is called when the copy button of an info item is pressed.
  final Function(String key, String value)? onCopyPressed;

  @override
  Widget build(BuildContext context) {
    final Color color = randomColor.color;

    return ListTileTheme(
      textColor: color_utils.contrastColor(color),
      iconColor: color_utils.contrastIconColor(randomColor.color),
      child: ListView(
        children: [
          // Add the color information list items
          if (randomColor.name != null) ...[
            _buildInfoItem(strings.colorTitleInfo, randomColor.title),
            _buildInfoItem(strings.colorNameInfo, randomColor.name!),
          ],
          _buildInfoItem(strings.hexInfo, color_utils.toHexString(color)),
          _buildInfoItem(strings.colorTypeInfo, strings.colorType[randomColor.type]!),
          _buildInfoItem(strings.rgbInfo, color_utils.toRGBString(color)),
          _buildInfoItem(strings.hsvInfo, color_utils.toHSVString(color)),
          _buildInfoItem(strings.hslInfo, color_utils.toHSLString(color)),
          _buildInfoItem(strings.decimalInfo, color_utils.toDecimalString(color)),
          _buildInfoItem(strings.luminanceInfo, color_utils.luminanceString(color)),
          _buildInfoItem(strings.brightnessInfo, color_utils.brightnessString(color)),
        ],
      ),
    );
  }

  /// Returns a color information list tile with the given [key] and [value].
  Widget _buildInfoItem(String key, String value) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      title: Text(value, style: const TextStyle(fontSize: 20.0)),
      subtitle: Text(key),
      trailing: IconButton(
        icon: const Icon(Icons.content_copy_outlined),
        onPressed: () => onCopyPressed?.call(key, value),
      ),
    );
  }
}
