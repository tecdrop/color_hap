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
    this.alignment = .start,
  });

  /// The color item containing the color data to display.
  final ColorItem colorItem;

  /// The contrast color to use for text (for readability against the background color).
  final Color contrastColor;

  /// Whether to show the color type label.
  final bool showType;

  /// The size preset for text styling.
  final ColorInfoSize size;

  /// The cross-axis alignment for the column (center or start).
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: alignment,
      mainAxisAlignment: .center,
      spacing: _getSpacing(),
      children: [
        // Color type (if shown and available)
        if (showType)
          Text(
            colorItem.type.name.toUpperCase(),
            style: _getTypeStyle(textTheme),
            textAlign: _getTextAlign(),
          ),

        // Color name (if available)
        if (colorItem.name != null)
          Text(
            colorItem.name!,
            style: _getNameStyle(textTheme),
            textAlign: _getTextAlign(),
          ),

        // Color hex code (always shown)
        Text(
          colorItem.hexString,
          style: _getHexStyle(textTheme),
          textAlign: _getTextAlign(),
        ),
      ],
    );
  }

  /// Returns the spacing between text elements based on size.
  double _getSpacing() {
    return switch (size) {
      .small => 2.0,
      .medium => 4.0,
      .large => 0.0,
    };
  }

  /// Returns the text alignment based on the column alignment.
  TextAlign _getTextAlign() {
    return alignment == .center ? .center : .start;
  }

  /// Returns the text style for the color type label.
  TextStyle _getTypeStyle(TextTheme textTheme) {
    return switch (size) {
      .small => textTheme.bodySmall!.copyWith(color: contrastColor),
      .medium => TextStyle(color: contrastColor, fontSize: 12.0),
      .large => textTheme.bodySmall!.copyWith(color: contrastColor),
    };
  }

  /// Returns the text style for the color name.
  TextStyle _getNameStyle(TextTheme textTheme) {
    return switch (size) {
      .small => textTheme.titleMedium!.copyWith(color: contrastColor),
      .medium => TextStyle(color: contrastColor, fontSize: 16.0, fontWeight: .bold),
      .large => textTheme.headlineMedium!.copyWith(color: contrastColor),
    };
  }

  /// Returns the text style for the hex code.
  TextStyle _getHexStyle(TextTheme textTheme) {
    final baseStyle = switch (size) {
      .small => textTheme.bodyMedium!.copyWith(color: contrastColor),
      .medium => TextStyle(color: contrastColor, fontSize: 16.0, fontFamily: 'monospace'),
      .large => _getLargeHexStyle(textTheme),
    };
    return baseStyle;
  }

  /// Returns the text style for hex code in large size (depends on whether name exists).
  TextStyle _getLargeHexStyle(TextTheme textTheme) {
    final baseThemeStyle = colorItem.name != null ? textTheme.titleMedium : textTheme.headlineMedium;
    return baseThemeStyle!.copyWith(color: contrastColor);
  }
}
