// Copyright 2020-2026 Tecdrop SRL. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file or at https://www.tecdrop.com/colorhap/license/.

import 'package:flutter/material.dart';

import '../models/color_item.dart';
import '../services/color_lookup_service.dart' as color_lookup;
import '../utils/color_utils.dart' as color_utils;
import 'color_list_view.dart';

/// A widget that displays a list of color shades for a given base color.
///
/// Generates 15 shades of the base color using HSL lightness variation and displays them
/// in a scrollable list. Each shade is checked against the known color catalog to provide
/// proper color names and types when available.
class ColorShadesList extends StatelessWidget {
  const ColorShadesList({
    super.key,
    required this.baseColor,
    required this.onShadeSelected,
  });

  /// The base color from which shades are generated.
  final Color baseColor;

  /// Callback invoked when a shade is selected.
  final ValueChanged<Color> onShadeSelected;

  /// Generates shades of the base color by varying the HSL lightness.
  ///
  /// Creates [count] shades distributed evenly across the lightness spectrum,
  /// from darkest to lightest.
  static List<Color> _generateShades(Color baseColor, {int count = 15}) {
    final shades = <Color>[];
    final hsl = HSLColor.fromColor(baseColor);

    for (var i = count - 1; i >= 0; i--) {
      final lightness = (i + 0.5) / count;
      final newHsl = hsl.withLightness(lightness);
      shades.add(newHsl.toColor());
    }

    return shades;
  }

  @override
  Widget build(BuildContext context) {
    final shades = _generateShades(baseColor);
    final shadeColorItems = shades.map((color) {
      // Check if this shade exists in any known catalog
      final knownColor = color_lookup.findKnownColor(color);
      if (knownColor != null) {
        return knownColor;
      }

      // Otherwise, return as a true color
      return ColorItem(
        type: .trueColor,
        color: color,
        listPosition: color_utils.toRGB24(color),
      );
    }).toList();

    return ColorListView(
      itemCount: shadeColorItems.length,
      itemData: (int index) => shadeColorItems[index],
      showColorType: (_) => true,
      onItemTap: (int index) => onShadeSelected(shadeColorItems[index].color),
    );
  }
}
