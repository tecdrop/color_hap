// Copyright 2020-2023 Tecdrop (www.tecdrop.com)
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../common/ui_strings.dart';
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
            _buildInfoItem(UIStrings.colorTitleInfo, randomColor.title),
            _buildInfoItem(UIStrings.colorNameInfo, randomColor.name!),
          ],
          _buildInfoItem(UIStrings.hexInfo, ColorUtils.toHexString(color)),
          _buildInfoItem(UIStrings.colorTypeInfo, UIStrings.colorType[randomColor.type]!),
          _buildInfoItem(UIStrings.rgbInfo, ColorUtils.toRGBString(color)),
          _buildInfoItem(UIStrings.hsvInfo, ColorUtils.toHSVString(color)),
          _buildInfoItem(UIStrings.hslInfo, ColorUtils.toHSLString(color)),
          _buildInfoItem(UIStrings.decimalInfo, ColorUtils.toDecimalString(color)),
          _buildInfoItem(UIStrings.luminanceInfo, ColorUtils.luminanceString(color)),
          _buildInfoItem(UIStrings.brightnessInfo, ColorUtils.brightnessString(color)),
        ],
      ),
    );
  }

  /// Returns a color information list tile with the given [key] and [value].
  Widget _buildInfoItem(String key, String value) {
    return ListTile(
      minVerticalPadding: 16.0,
      subtitle: Text(key),
      title: Text(value, style: const TextStyle(fontSize: 22.0)),
      onTap: () => onInfoItemTap?.call(key, value),
    );
  }
}
