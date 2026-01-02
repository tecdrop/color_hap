// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';

import '../models/color_item.dart';

/// The size preset for displaying color information.
enum ColorInfoSize {
  /// Small size used in color list items.
  small,

  /// Medium size used in the color tweak screen.
  medium,

  /// Large size used in the main random color display.
  large,
}

/// A reusable widget that displays color information (type, name, and hex code).
///
/// This widget is a pure presentation component that renders color metadata
/// in a vertical column. It does not include any interaction, decoration, or
/// container widgets - those are the responsibility of the parent widget.
class ColorInfoDisplay extends StatelessWidget {
  const ColorInfoDisplay({
    super.key,
    required this.colorItem,
    required this.contrastColor,
    this.showType = true,
    this.size = .medium,
    this.centered = false,
    this.adaptiveHexSize = true,
  });

  /// The color item containing the color data to display.
  final ColorItem colorItem;

  /// The contrast color to use for text (for readability against the background color).
  final Color contrastColor;

  /// Whether to show the color type label.
  final bool showType;

  /// The size preset for text styling.
  final ColorInfoSize size;

  /// Whether to center-align the text (true) or start-align (false).
  final bool centered;

  /// Whether to adaptively scale hex code size when no color name is present (large size only).
  final bool adaptiveHexSize;

  /// Text theme style getters for the color type label.
  static const _typeStyleGetters = {
    ColorInfoSize.small: _getBodySmall,
    ColorInfoSize.medium: _getBodySmall,
    ColorInfoSize.large: _getBodySmall,
  };

  /// Text theme style getters for the color name.
  static const _nameStyleGetters = {
    ColorInfoSize.small: _getTitleMedium,
    ColorInfoSize.medium: _getTitleLarge,
    ColorInfoSize.large: _getHeadlineMedium,
  };

  /// Text theme style getters for the hex code (when name is present or adaptiveHexSize is off).
  static const _hexStyleGetters = {
    ColorInfoSize.small: _getBodyMedium,
    ColorInfoSize.medium: _getBodyLarge,
    ColorInfoSize.large: _getTitleMedium,
  };

  /// Text theme style getters for the hex code when name is absent and adaptiveHexSize is on.
  static const _hexStyleGettersAdaptive = {
    ColorInfoSize.small: _getBodyMedium,
    ColorInfoSize.medium: _getBodyLarge,
    ColorInfoSize.large: _getHeadlineMedium,
  };

  /// Spacing values for each size.
  static const _spacingValues = {
    ColorInfoSize.small: 2.0,
    ColorInfoSize.medium: 4.0,
    ColorInfoSize.large: 0.0,
  };

  // Theme style getter functions
  static TextStyle _getBodySmall(TextTheme theme) => theme.bodySmall!;
  static TextStyle _getBodyMedium(TextTheme theme) => theme.bodyMedium!;
  static TextStyle _getBodyLarge(TextTheme theme) => theme.bodyLarge!;
  static TextStyle _getTitleMedium(TextTheme theme) => theme.titleMedium!;
  static TextStyle _getTitleLarge(TextTheme theme) => theme.titleLarge!;
  static TextStyle _getHeadlineMedium(TextTheme theme) => theme.headlineMedium!;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final textAlign = centered ? TextAlign.center : TextAlign.start;
    final crossAxisAlignment = centered ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: .center,
      spacing: _spacingValues[size]!,
      children: [
        // Color type (if shown)
        if (showType)
          Text(
            colorItem.type.name.toUpperCase(),
            style: _typeStyleGetters[size]!(textTheme).copyWith(color: contrastColor),
            textAlign: textAlign,
          ),

        // Color name (if available)
        if (colorItem.name != null)
          Text(
            colorItem.name!,
            style: _nameStyleGetters[size]!(textTheme).copyWith(color: contrastColor),
            textAlign: textAlign,
          ),

        // Color hex code (always shown)
        Text(
          colorItem.hexString,
          style: _getHexStyle(textTheme),
          textAlign: textAlign,
        ),
      ],
    );
  }

  /// Returns the text style for the hex code, with optional adaptive sizing.
  TextStyle _getHexStyle(TextTheme textTheme) {
    // Use adaptive style when adaptiveHexSize is enabled and no name is present
    final styleGetter = (adaptiveHexSize && colorItem.name == null)
        ? _hexStyleGettersAdaptive[size]!
        : _hexStyleGetters[size]!;

    return styleGetter(textTheme).copyWith(color: contrastColor);
  }
}
