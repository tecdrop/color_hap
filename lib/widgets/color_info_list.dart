// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../common/ui_strings.dart' as strings;
import '../models/random_color.dart';
import '../utils/color_utils.dart';

/// A list view of color information items.
class ColorInfoList extends StatelessWidget {
  /// Creates a new [ColorInfoList] instance.
  const ColorInfoList({
    super.key,
    required this.randomColor,
    this.onInfoItemTap,
  });

  /// The random color whose information is displayed in the list.
  final RandomColor randomColor;

  /// A callback function that is called when a color information item is tapped.
  final Function(String key, String value)? onInfoItemTap;

  @override
  Widget build(BuildContext context) {
    final Color color = randomColor.color;
    final Color contrastColor = ColorUtils.contrastOf(color);

    return ListTileTheme(
      textColor: contrastColor,
      child: ListView(
        children: [
          // Add the color information list items
          if (randomColor.name != null) ...[
            _buildInfoItem(strings.colorTitleInfo, randomColor.title),
            _buildInfoItem(strings.colorNameInfo, randomColor.name!),
          ],
          _buildInfoItem(strings.hexInfo, ColorUtils.toHexString(color)),
          _buildInfoItem(strings.colorTypeInfo, strings.colorType[randomColor.type]!),
          _buildInfoItem(strings.rgbInfo, ColorUtils.toRGBString(color)),
          _buildInfoItem(strings.hsvInfo, ColorUtils.toHSVString(color)),
          _buildInfoItem(strings.hslInfo, ColorUtils.toHSLString(color)),
          _buildInfoItem(strings.decimalInfo, ColorUtils.toDecimalString(color)),
          _buildInfoItem(strings.luminanceInfo, ColorUtils.luminanceString(color)),
          _buildInfoItem(strings.brightnessInfo, ColorUtils.brightnessString(color)),
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
      onTap: () => onInfoItemTap?.call(key, value),
    );
  }
}
